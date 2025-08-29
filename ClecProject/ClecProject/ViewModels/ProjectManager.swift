//
//  ProjectManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation
import SwiftUI

class ProjectManager: ObservableObject {
    @Published var projects: [ProjectModel] = []
    
    private let userDefaults = UserDefaults.standard
    private let projectsKey = "SavedProjects"
    
    // Computed property para verificar se há projetos
    var hasProjects: Bool {
        return !projects.isEmpty
    }
    
    init() {
        loadProjects()
    }
    
    // MARK: - Project Management
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
    
    // MARK: - Persistence
    private func loadProjects() {
        // Por agora, vamos usar uma implementação simples
        // Futuramente implementaremos com Codable + UserDefaults ou Core Data
        
        // Dados mock para desenvolvimento
        #if DEBUG
        if projects.isEmpty {
            print("📱 Carregando projetos salvos...")
            // Para testar, não vamos carregar projetos automaticamente
            // deixa começar sempre vazio
        }
        #endif
    }
    
    private func saveProjects() {
        // Por agora, só print. Futuramente implementar persistência real
        print("💾 Salvando \(projects.count) projetos...")
        
        // TODO: Implementar Codable + UserDefaults
        /*
        do {
            let data = try JSONEncoder().encode(projects)
            userDefaults.set(data, forKey: projectsKey)
            print("✅ Projetos salvos com sucesso")
        } catch {
            print("❌ Erro ao salvar projetos: \(error)")
        }
        */
    }
    
    // MARK: - Utility
    func clearAllProjects() {
        projects.removeAll()
        saveProjects()
        print("🧹 Todos os projetos foram removidos")
    }
    
    // MARK: - Mock Data (for development)
    func addMockProject() {
        let mockProject = ProjectModel(
            id: UUID(),
            code: "1234",
            director: "João Silva",
            name: "Projeto Teste",
            photo: nil,
            screenPlay: "Um roteiro de exemplo para testar o app",
            deadline: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            callSheet: []
        )
        addProject(mockProject)
    }
}
