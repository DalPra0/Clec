//
//  ProjectManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation
import SwiftUI

class ProjectManager: ObservableObject {
    public var selectedProject = 0
    @Published var projects: [ProjectModel] = []
    
    private let userDefaults = UserDefaults.standard
    private let projectsKey = "SavedProjects"
    
    var hasProjects: Bool {
        return !projects.isEmpty
    }
    
    var currentProject: ProjectModel { //temporario, precisamos discutir melhor esse project manager
        return projects[selectedProject]
    }
    
    init() {
        loadProjects()
    }
    
    func addProject(_ project: ProjectModel) {
        projects.append(project)
        saveProjects()
        print("✅ Projeto '\(project.name)' adicionado com código: \(project.code)")
    }
    
    func removeProject(at index: Int) {
        let removedProject = projects[index]
        projects.remove(at: index)
        saveProjects()
        print("🗑️ Projeto '\(removedProject.name)' removido")
    }
    
    func removeProject(by id: UUID) {
        if let index = projects.firstIndex(where: { $0.id == id }) {
            removeProject(at: index)
        }
    }
    
    func getProject(by code: String) -> ProjectModel? {
        return projects.first { $0.code == code }
    }
    
    func getProject(by id: UUID) -> ProjectModel? {
        return projects.first { $0.id == id }
    }
    
    func addCallSheetToCurrentProject(title: String, description: String, address: String, date: Date, color: CallSheetModel.CallSheetColor) {
        guard projects.indices.contains(selectedProject) else {
            print("❌ Projeto selecionado é inválido.")
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
        
        projects[selectedProject].callSheet.append(newCallSheet)
        saveProjects()
        
        print("✅ Nova diária adicionada ao projeto: \(projects[selectedProject].name)")
    }
    
    // MARK: - File Management
    func addFileToProject(at index: Int, file: ProjectFile) {
        guard projects.indices.contains(index) else {
            print("❌ Projeto no índice \(index) não encontrado")
            return
        }
        
        projects[index].additionalFiles.append(file)
        saveProjects()
        
        print("✅ Arquivo '\(file.displayName)' adicionado ao projeto '\(projects[index].name)'")
    }
    
    func addFileToCurrentProject(file: ProjectFile) {
        addFileToProject(at: selectedProject, file: file)
    }
    
    func removeFileFromProject(at projectIndex: Int, fileId: UUID) {
        guard projects.indices.contains(projectIndex) else {
            print("❌ Projeto no índice \(projectIndex) não encontrado")
            return
        }
        
        if let fileIndex = projects[projectIndex].additionalFiles.firstIndex(where: { $0.id == fileId }) {
            let removedFile = projects[projectIndex].additionalFiles[fileIndex]
            projects[projectIndex].additionalFiles.remove(at: fileIndex)
            saveProjects()
            
            print("🗑️ Arquivo '\(removedFile.displayName)' removido do projeto '\(projects[projectIndex].name)'")
        } else {
            print("❌ Arquivo com ID \(fileId) não encontrado")
        }
    }
    
    func removeFileFromCurrentProject(fileId: UUID) {
        removeFileFromProject(at: selectedProject, fileId: fileId)
    }
    
    func updateFileInProject(at projectIndex: Int, updatedFile: ProjectFile) {
        guard projects.indices.contains(projectIndex) else {
            print("❌ Projeto no índice \(projectIndex) não encontrado")
            return
        }
        
        if let fileIndex = projects[projectIndex].additionalFiles.firstIndex(where: { $0.id == updatedFile.id }) {
            projects[projectIndex].additionalFiles[fileIndex] = updatedFile
            saveProjects()
            
            print("✅ Arquivo '\(updatedFile.displayName)' atualizado no projeto '\(projects[projectIndex].name)'")
        } else {
            print("❌ Arquivo com ID \(updatedFile.id) não encontrado para atualizar")
        }
    }
    
    private func loadProjects() {
        print("📱 Carregando projetos salvos...")
        
        if let data = userDefaults.data(forKey: projectsKey) {
            do {
                let loadedProjects = try JSONDecoder().decode([ProjectModel].self, from: data)
                self.projects = loadedProjects
                print("✅ \(loadedProjects.count) projetos carregados com sucesso")
            } catch {
                print("❌ Erro ao carregar projetos: \(error.localizedDescription)")
                print("🔄 Iniciando com lista vazia")
            }
        } else {
            print("🆆 Nenhum projeto salvo encontrado - primeira execução")
        }
        
        #if DEBUG
        // Para desenvolvimento - descomente para adicionar projetos mock:
        // if projects.isEmpty { addMockProjects() }
        #endif
    }
    
    private func saveProjects() {
        print("💾 Salvando \(projects.count) projetos...")
        
        do {
            let data = try JSONEncoder().encode(projects)
            userDefaults.set(data, forKey: projectsKey)
            print("✅ Projetos salvos com sucesso")
        } catch {
            print("❌ Erro ao salvar projetos: \(error.localizedDescription)")
        }
    }
    
    func clearAllProjects() {
        projects.removeAll()
        saveProjects()
        print("🧹 Todos os projetos foram removidos e salvos")
    }
    
    func addMockProjects() {
        let mockFiles1 = [
            ProjectFile(
                name: "Storyboard Cena 1",
                fileName: "storyboard_cena1.jpg",
                fileType: .jpg,
                fileSize: "2.3 MB"
            ),
            ProjectFile(
                name: "Cronograma de Filmagem",
                fileName: "cronograma.docx",
                fileType: .docx,
                fileSize: "156 KB"
            )
        ]
        
        let mockFiles2 = [
            ProjectFile(
                name: "Referências Visuais",
                fileName: "referencias.zip",
                fileType: .zip,
                fileSize: "5.2 MB"
            ),
            ProjectFile(
                name: "Orçamento",
                fileName: "orcamento.pdf",
                fileType: .pdf,
                fileSize: "890 KB"
            ),
            ProjectFile(
                name: "Playlist Trilha Sonora",
                fileName: "trilha_sonora.m4a",
                fileType: .m4a,
                fileSize: "12.4 MB"
            )
        ]
        
        let mockProjects = [
            ProjectModel(
                id: UUID(),
                code: "AB12",
                director: "João Silva",
                name: "Curta Metragem - O Início",
                photo: nil,
                screenPlay: "roteiro_inicio.pdf",
                deadline: Calendar.current.date(byAdding: .day, value: 15, to: Date()),
                additionalFiles: mockFiles1,
                callSheet: []
            ),
            ProjectModel(
                id: UUID(),
                code: "XY9Z",
                director: "Maria Santos",
                name: "Documentário Natureza",
                photo: nil,
                screenPlay: "doc_natureza.docx",
                deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
                additionalFiles: mockFiles2,
                callSheet: []
            ),
            ProjectModel(
                id: UUID(),
                code: "P7Q8",
                director: "Carlos Lima",
                name: "Filme Experimental",
                photo: nil,
                screenPlay: nil,
                deadline: Calendar.current.date(byAdding: .day, value: 45, to: Date()),
                additionalFiles: [],
                callSheet: []
            )
        ]
        
        for project in mockProjects {
            if !projects.contains(where: { $0.code == project.code }) {
                projects.append(project)
            }
        }
        
        saveProjects()
        
        print("📚 Adicionados \(mockProjects.count) projetos mock e salvos com persistência")
        print("🔑 Códigos de teste: AB12, XY9Z, P7Q8")
    }
}
