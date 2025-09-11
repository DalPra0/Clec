//
//  ProjectManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class ProjectManager: ObservableObject {
    @Published var projects: [ProjectModel] = []
    @Published var activeProject: ProjectModel?

    private let db = Firestore.firestore()
    private var projectsListener: ListenerRegistration?
    private let weatherService = WeatherService.shared
    private var forecastCache: [Date: DailyForecast] = [:]

    // 🔥 Referência ao UserManager para manter sincronizado
    private var userManager: UserManager?

    var hasProjects: Bool {
        return !projects.isEmpty
    }

    // ✅ Init usado no preview e em testes
    init() {
        self.userManager = nil
        _ = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                self?.setupProjectsListener(for: user.uid)
            } else {
                self?.detachProjectsListener()
                self?.projects = []
                self?.activeProject = nil
            }
        }
    }

    // ✅ Init oficial usado no app, com UserManager
    init(userManager: UserManager?) {
        self.userManager = userManager
        _ = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                self?.setupProjectsListener(for: user.uid)
            } else {
                self?.detachProjectsListener()
                self?.projects = []
                self?.activeProject = nil
            }
        }
    }

    deinit {
        detachProjectsListener()
    }

    func setupProjectsListener(for userId: String) {
        detachProjectsListener()

        let query = db.collection("projects").whereField("members", arrayContains: userId)

        projectsListener = query.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching projects: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                self.projects = []
                return
            }

            self.projects = documents.compactMap { document -> ProjectModel? in
                try? document.data(as: ProjectModel.self)
            }

            // 🔄 Buscar projeto ativo salvo no usuário
            self.restoreActiveProject(for: userId)
        }
    }

    private func restoreActiveProject(for userId: String) {
        db.collection("users").document(userId).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else { return }

            if let activeId = data["activeProjectId"] as? String {
                if let project = self.projects.first(where: { $0.id == activeId }) {
                    self.activeProject = project
                    self.userManager?.activeProjectId = project.id   // 🔥 sincroniza com UserManager
                    print("✅ Projeto ativo restaurado: \(project.name)")
                } else {
                    print("⚠️ Projeto ativo salvo não encontrado entre os projetos do usuário")
                }
            } else if self.projects.count == 1 {
                self.activeProject = self.projects.first
                self.userManager?.activeProjectId = self.projects.first?.id
                print("ℹ️ Apenas um projeto encontrado, definindo como ativo automaticamente")
            }
        }
    }

    func detachProjectsListener() {
        projectsListener?.remove()
    }

    func addProject(_ project: ProjectModel) {
        do {
            _ = try db.collection("projects").addDocument(from: project)
        } catch {
            print("Error adding project to Firestore: \(error.localizedDescription)")
        }
    }

    func joinProject(withCode code: String, completion: @escaping (ProjectModel?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let query = db.collection("projects").whereField("code", isEqualTo: code).limit(to: 1)

        query.getDocuments { snapshot, _ in
            guard let document = snapshot?.documents.first else {
                completion(nil)
                return
            }

            let projectId = document.documentID
            self.db.collection("projects").document(projectId).updateData([
                "members": FieldValue.arrayUnion([userId])
            ]) { err in
                if err != nil {
                    completion(nil)
                } else {
                    if var project = try? document.data(as: ProjectModel.self) {
                        project.members.append(userId)
                        completion(project)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }

    func removeProject(_ project: ProjectModel) {
        guard let projectId = project.id else { return }
        db.collection("projects").document(projectId).delete()
    }
    
    func leaveProject(_ project: ProjectModel, completion: @escaping (Bool) -> Void) {
        guard let projectId = project.id,
              let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        db.collection("projects").document(projectId).updateData([
            "members": FieldValue.arrayRemove([userId])
        ]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error leaving project: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("✅ Successfully left project: \(project.name)")
                    
                    if self.activeProject?.id == projectId {
                        self.setActiveProject(nil)
                    }
                    
                    completion(true)
                }
            }
        }
    }

    func setActiveProject(_ project: ProjectModel?) {
        self.activeProject = project
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let projectId = project?.id
        db.collection("users").document(userId).setData(
            ["activeProjectId": projectId ?? NSNull()],
            merge: true
        )

        // 🔥 sincroniza com UserManager também
        self.userManager?.activeProjectId = projectId
    }

    // MARK: - Call Sheet Management
    
    func createCallSheetWithFirstScene(callSheetTitle: String, date: Date, color: CallSheetModel.CallSheetColor, sceneDescription: String, sceneAddress: String, sceneTime: Date) {
        guard let projectId = activeProject?.id else { return }
        
        if activeProject?.callSheet.contains(where: { Calendar.current.isDate($0.day, inSameDayAs: date) }) ?? false {
            print("⚠️ A call sheet for this day already exists.")
            // Optionally, we could add the scene to the existing sheet here, but for now we'll just prevent duplicates.
            return
        }

        let newLocation = SceneLocation(name: sceneAddress, address: sceneAddress, latitude: 0.0, longitude: 0.0)
        let newEnvironment = EnvironmentConditions(environment: "INT./EXT.", dayCycle: "DAY", weather: "Ensolarado")
        let firstScene = CallSheetLineInfo(
            scene: 1,
            shots: [1],
            environmentCondition: newEnvironment,
            location: newLocation,
            description: sceneDescription,
            characters: []
        )
        
        let schedule = [SchedulePair(scheduleActivity: .Begginning, time: sceneTime)]

        let newCallSheet = CallSheetModel(
            id: UUID(),
            sheetName: callSheetTitle,
            day: date,
            schedule: schedule,
            callSheetColor: color,
            sceneTable: [firstScene]
        )

        do {
            let callSheetData = try Firestore.Encoder().encode(newCallSheet)
            db.collection("projects").document(projectId).updateData([
                "callSheet": FieldValue.arrayUnion([callSheetData])
            ])
        } catch {
             print("Error encoding call sheet: \(error.localizedDescription)")
        }
    }

    func addSceneToDay(date: Date, title: String, description: String, address: String, time: Date, responsible: String) {
        guard let projectId = activeProject?.id else { return }

        let newLocation = SceneLocation(name: address, address: address, latitude: 0.0, longitude: 0.0)
        let newEnvironment = EnvironmentConditions(environment: "INT./EXT.", dayCycle: "DIA", weather: "Ensolarado")

        let sceneNumber = (activeProject?.callSheet.flatMap({$0.sceneTable}).count ?? 0) + 1
        let newScene = CallSheetLineInfo(
            scene: sceneNumber,
            shots: [1],
            environmentCondition: newEnvironment,
            location: newLocation,
            description: description,
            characters: []
        )

        if let dayIndex = activeProject?.callSheet.firstIndex(where: { Calendar.current.isDate($0.day, inSameDayAs: date) }) {
            var allCallSheets = activeProject!.callSheet
            allCallSheets[dayIndex].sceneTable.append(newScene)
            updateCallSheetsInFirestore(projectId: projectId, callSheets: allCallSheets)
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "pt_BR")
            
            let newCallSheet = CallSheetModel(
                id: UUID(),
                sheetName: "Diária - \(formatter.string(from: date))",
                day: date,
                schedule: [],
                callSheetColor: .blue, // Default color for auto-created sheets
                sceneTable: [newScene]
            )

            do {
                let callSheetData = try Firestore.Encoder().encode(newCallSheet)
                db.collection("projects").document(projectId).updateData([
                    "callSheet": FieldValue.arrayUnion([callSheetData])
                ])
            } catch {
                 print("Error encoding call sheet: \(error.localizedDescription)")
            }
        }
    }

    private func updateCallSheetsInFirestore(projectId: String, callSheets: [CallSheetModel]) {
        do {
            let encodedCallSheets = try callSheets.map { try Firestore.Encoder().encode($0) }
            db.collection("projects").document(projectId).updateData(["callSheet": encodedCallSheets])
        } catch {
            print("Error updating call sheets in Firestore: \(error.localizedDescription)")
        }
    }

    func addFileToProject(at projectIndex: Int, file: ProjectFile) {
        guard projects.indices.contains(projectIndex), let projectId = projects[projectIndex].id else {
            return
        }

        do {
            let fileData = try Firestore.Encoder().encode(file)
            db.collection("projects").document(projectId).updateData([
                "additionalFiles": FieldValue.arrayUnion([fileData])
            ])
        } catch {
            print("Error encoding file: \(error.localizedDescription)")
        }
    }

    func removeFileFromProject(at projectIndex: Int, fileId: UUID) {
        guard projects.indices.contains(projectIndex),
              let projectId = projects[projectIndex].id,
              let fileToRemove = projects[projectIndex].additionalFiles.first(where: { $0.id == fileId })
        else {
            return
        }

        do {
            let fileData = try Firestore.Encoder().encode(fileToRemove)
            db.collection("projects").document(projectId).updateData([
                "additionalFiles": FieldValue.arrayRemove([fileData])
            ])
        } catch {
            print("Error encoding file for removal: \(error.localizedDescription)")
        }
    }

    func updateFileInProject(at projectIndex: Int, updatedFile: ProjectFile) {
        guard projects.indices.contains(projectIndex), let projectId = projects[projectIndex].id else {
            return
        }

        var project = projects[projectIndex]
        guard let fileIndex = project.additionalFiles.firstIndex(where: { $0.id == updatedFile.id }) else {
            return
        }

        project.additionalFiles[fileIndex] = updatedFile
        
        do {
            let updatedFilesData = try project.additionalFiles.map { try Firestore.Encoder().encode($0) }
            db.collection("projects").document(projectId).updateData(["additionalFiles": updatedFilesData])
        } catch {
            print("Error updating file in project: \(error.localizedDescription)")
        }
    }

    func dayHasActivities(_ date: Date) -> Bool {
        guard let project = activeProject else { return false }
        return project.callSheet.contains { callSheet in
            Calendar.current.isDate(callSheet.day, inSameDayAs: date) && !callSheet.sceneTable.isEmpty
        }
    }

    func getActivitiesForDay(_ date: Date) -> [CallSheetLineInfo] {
        guard let project = activeProject else { return [] }
        return project.callSheet
            .filter { Calendar.current.isDate($0.day, inSameDayAs: date) }
            .flatMap { $0.sceneTable }
            .sorted { $0.scene < $1.scene }
    }
    
    func getForecast(for day: Date, completion: @escaping (DailyForecast?) -> Void) {
        guard let project = activeProject else {
            completion(nil)
            return
        }

        let calendar = Calendar.current
        
        if let cachedForecast = forecastCache.first(where: { calendar.isDate($0.key, inSameDayAs: day) })?.value {
            completion(cachedForecast)
            return
        }

        var location: CLLocation?
        if let sceneForDay = project.callSheet.first(where: { calendar.isDate($0.day, inSameDayAs: day) })?.sceneTable.first {
            location = CLLocation(latitude: sceneForDay.location.latitude, longitude: sceneForDay.location.longitude)
        } else if let firstSceneInProject = project.callSheet.first?.sceneTable.first {
            location = CLLocation(latitude: firstSceneInProject.location.latitude, longitude: firstSceneInProject.location.longitude)
        }

        guard let finalLocation = location else {
            completion(nil)
            return
        }

        Task {
            do {
                let forecastCollection = try await weatherService.fetchForecast(for: finalLocation)
                let forecastForDay = forecastCollection.first { calendar.isDate($0.date, inSameDayAs: day) }
                
                await MainActor.run {
                    if let forecast = forecastForDay {
                        forecastCache[day] = forecast
                    }
                    completion(forecastForDay)
                }
            } catch {
                await MainActor.run {
                    completion(nil)
                }
            }
        }
    }
}
