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

    var hasProjects: Bool {
        return !projects.isEmpty
    }

    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
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

            if let currentActiveId = self.activeProject?.id {
                self.activeProject = self.projects.first { $0.id == currentActiveId }
            } else if self.projects.count == 1 {
                self.activeProject = self.projects.first
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

        query.getDocuments { snapshot, error in
            if let error = error {
                completion(nil)
                return
            }

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

    func addActivityToDay(date: Date, title: String, description: String, address: String, time: Date, responsible: String) {
        guard let projectId = activeProject?.id else { return }

        let newLocation = SceneLocation(name: "Nova Locação", address: address, latitude: 0.0, longitude: 0.0)
        let newEnvironment = EnvironmentConditions(environment: "INT./EXT.", dayCycle: "DIA", weather: "Ensolarado")

        let newCallSheetLine = CallSheetLineInfo(
            scene: (activeProject?.callSheet.flatMap({$0.sceneTable}).count ?? 0) + 1,
            shots: [1],
            environmentCondition: newEnvironment,
            location: newLocation,
            description: description,
            characters: []
        )

        if let dayIndex = activeProject?.callSheet.firstIndex(where: { Calendar.current.isDate($0.day, inSameDayAs: date) }) {
            var allCallSheets = activeProject!.callSheet
            allCallSheets[dayIndex].sceneTable.append(newCallSheetLine)
            updateCallSheetsInFirestore(projectId: projectId, callSheets: allCallSheets)

        } else {
            let newCallSheet = CallSheetModel(
                id: UUID(),
                sheetName: title,
                day: date,
                schedule: [],
                callSheetColor: .blue,
                sceneTable: [newCallSheetLine]
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

    func setActiveProject(_ project: ProjectModel?) {
        self.activeProject = project
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
