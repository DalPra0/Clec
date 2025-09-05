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

class ProjectManager: ObservableObject {
    @Published var projects: [ProjectModel] = []
    public var selectedProject = 0

    private let db = Firestore.firestore()
    private var projectsListener: ListenerRegistration?

    var hasProjects: Bool {
        return !projects.isEmpty
    }

    var currentProject: ProjectModel? {
        guard projects.indices.contains(selectedProject), let id = projects[selectedProject].id else { return nil }
        return projects.first { $0.id == id }
    }

    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                self?.setupProjectsListener(for: user.uid)
            } else {
                self?.detachProjectsListener()
                self?.projects = []
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
                print("No project documents found.")
                return
            }
            
            self.projects = documents.compactMap { document -> ProjectModel? in
                try? document.data(as: ProjectModel.self)
            }
        }
    }
    
    func detachProjectsListener() {
        projectsListener?.remove()
    }

    func addProject(_ project: ProjectModel) {
        guard let projectId = project.id else {
            return
        }
        
        do {
            try db.collection("projects").document(projectId).setData(from: project)
        } catch {
            print("Error adding project to Firestore: \(error.localizedDescription)")
        }
    }

    func removeProject(at index: Int) {
        guard projects.indices.contains(index), let projectId = projects[index].id else { return }
        db.collection("projects").document(projectId).delete()
    }
    
    func removeProject(by id: String) {
        db.collection("projects").document(id).delete()
    }
    
    func getProject(by id: String) -> ProjectModel? {
        return projects.first { $0.id == id }
    }

    func addCallSheetToCurrentProject(title: String, description: String, address: String, date: Date, color: CallSheetModel.CallSheetColor) {
        guard let currentProjectId = currentProject?.id else {
            return
        }

        let newLocation = SceneLocation(name: "Nova Locação", address: address, latitude: 0.0, longitude: 0.0)
        let newEnvironment = EnvironmentConditions(environment: "INT./EXT.", dayCycle: "DIA", weather: "Ensolarado")
        
        let newCallSheetLine = CallSheetLineInfo(
            scene: 1,
            shots: [1],
            environmentCondition: newEnvironment,
            location: newLocation,
            description: title,
            characters: []
        )
        
        let newCallSheet = CallSheetModel(
            id: UUID(),
            sheetName: title,
            day: date,
            schedule: [],
            callSheetColor: color,
            sceneTable: [newCallSheetLine]
        )
        
        do {
            let callSheetData = try Firestore.Encoder().encode(newCallSheet)
            db.collection("projects").document(currentProjectId).updateData([
                "callSheet": FieldValue.arrayUnion([callSheetData])
            ])
        } catch {
            print("Error encoding call sheet: \(error.localizedDescription)")
        }
    }

    func addFileToProject(at index: Int, file: ProjectFile) {
        guard projects.indices.contains(index), let projectId = projects[index].id else {
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
    
    func addFileToCurrentProject(file: ProjectFile) {
        addFileToProject(at: selectedProject, file: file)
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
    
    func removeFileFromCurrentProject(fileId: UUID) {
        removeFileFromProject(at: selectedProject, fileId: fileId)
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
            try db.collection("projects").document(projectId).setData(from: project, merge: true)
        } catch {
            print("Error updating file in project: \(error.localizedDescription)")
        }
    }
}
