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
    
    var currentProject: ProjectModel {
        print(selectedProject)
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
        let mockProjects = [
            ProjectModel(
                id: UUID(),
                code: "AB12",
                director: "João Silva",
                name: "Curta Metragem - O Início",
                photo: nil,
                screenPlay: "roteiro_inicio.pdf",
                deadline: Calendar.current.date(byAdding: .day, value: 15, to: Date()),
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
