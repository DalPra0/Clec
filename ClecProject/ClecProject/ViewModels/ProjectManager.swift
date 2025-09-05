//
//  ProjectManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

// 🔥 FIREBASE TODO: Este é o arquivo PRINCIPAL para Firebase integration!
// 🔥   PRINCIPAIS MUDANÇAS NECESSÁRIAS:
// 🔥   - import FirebaseFirestore, FirebaseAuth
// 🔥   - Substituir UserDefaults por Firestore Database
// 🔥   - loadProjects() → loadFromFirestore()
// 🔥   - saveProjects() → saveToFirestore() 
// 🔥   - Adicionar user authentication (userId)
// 🔥   - Sync em tempo real com listeners
// 🔥   - Error handling para network failures

import Foundation
import SwiftUI

class ProjectManager: ObservableObject {
    // Sistema de projeto ativo único - NOVA ARQUITETURA
    @Published var activeProject: ProjectModel?
    @Published var projects: [ProjectModel] = [] // Para histórico/backup
    
    // FIREBASE TODO: Substituir por Firestore
    private let userDefaults = UserDefaults.standard
    private let projectsKey = "SavedProjects"
    private let activeProjectKey = "ActiveProject"
    
    // Computed properties para compatibilidade e fluxo novo
    var hasActiveProject: Bool {
        return activeProject != nil
    }
    
    var hasProjects: Bool {
        return hasActiveProject
    }
    
    var currentProject: ProjectModel? {
        return activeProject
    }
    
    init() {
        loadProjects()
        loadActiveProject()
    }
    
    // MARK: - Active Project Management
    func setActiveProject(_ project: ProjectModel) {
        activeProject = project
        saveActiveProject()
        print("✅ Projeto ativo definido: \(project.name)")
    }
    
    func clearActiveProject() {
        activeProject = nil
        userDefaults.removeObject(forKey: activeProjectKey)
        print("🧹 Projeto ativo removido")
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
    
    // MARK: - Activity Management (NEW LOGIC)
    func addActivityToDay(date: Date, title: String, description: String, address: String, time: Date, responsible: String) {
        guard var project = activeProject else {
            print("❌ Nenhum projeto ativo para adicionar atividade")
            return
        }
        
        let calendar = Calendar.current
        
        // Buscar se já existe uma diária para esse dia
        if let existingCallSheetIndex = project.callSheet.firstIndex(where: { callSheet in
            calendar.isDate(callSheet.day, inSameDayAs: date)
        }) {
            // Já existe diária - adicionar atividade
            let newActivity = CallSheetLineInfo(
                scene: project.callSheet[existingCallSheetIndex].sceneTable.count + 1,
                shots: [1],
                environmentCondition: EnvironmentConditions(environment: "INT./EXT.", dayCycle: "DIA", weather: "Ensolarado"),
                location: SceneLocation(name: title, address: address, latitude: 0.0, longitude: 0.0),
                description: description,
                characters: []
            )
            
            project.callSheet[existingCallSheetIndex].sceneTable.append(newActivity)
            print("✅ Atividade '\(title)' adicionada à diária existente do dia \(formatDate(date))")
        } else {
            // Não existe diária - criar nova diária para o dia
            let newActivity = CallSheetLineInfo(
                scene: 1,
                shots: [1],
                environmentCondition: EnvironmentConditions(environment: "INT./EXT.", dayCycle: "DIA", weather: "Ensolarado"),
                location: SceneLocation(name: title, address: address, latitude: 0.0, longitude: 0.0),
                description: description,
                characters: []
            )
            
            let dailyCallSheet = CallSheetModel(
                id: UUID(),
                sheetName: "Diária \(formatDate(date))",
                day: date,
                schedule: [],
                callSheetColor: getNextColor(for: project),
                sceneTable: [newActivity]
            )
            
            project.callSheet.append(dailyCallSheet)
            print("✅ Nova diária criada para \(formatDate(date)) com atividade '\(title)'")
        }
        
        // Atualizar projeto ativo
        activeProject = project
        saveActiveProject()
        updateProjectInHistory(project)
        
        print("🎬 Atividade '\(title)' adicionada com sucesso ao dia \(formatDate(date))")
    }
    
    private func getNextColor(for project: ProjectModel) -> CallSheetModel.CallSheetColor {
        let colors: [CallSheetModel.CallSheetColor] = [.blue, .green, .yellow, .purple]
        let existingColors = Set(project.callSheet.map { $0.callSheetColor })
        
        // Tentar encontrar uma cor não usada
        for color in colors {
            if !existingColors.contains(color) {
                return color
            }
        }
        
        // Se todas as cores foram usadas, usar baseado no índice
        return colors[project.callSheet.count % colors.count]
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
    
    // Função para buscar todas atividades de um dia específico
    func getActivitiesForDay(_ date: Date) -> [CallSheetLineInfo] {
        guard let project = activeProject else { return [] }
        
        let calendar = Calendar.current
        
        // Buscar CallSheet do dia
        if let dayCallSheet = project.callSheet.first(where: { callSheet in
            calendar.isDate(callSheet.day, inSameDayAs: date)
        }) {
            return dayCallSheet.sceneTable
        }
        
        return []
    }
    
    // Função para verificar se um dia tem atividades
    func dayHasActivities(_ date: Date) -> Bool {
        return !getActivitiesForDay(date).isEmpty
    }
    
    // MARK: - File Management (maintained for FilesView compatibility)
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
        guard var project = activeProject else {
            print("❌ Nenhum projeto ativo para adicionar arquivo")
            return
        }
        
        project.additionalFiles.append(file)
        activeProject = project
        saveActiveProject()
        updateProjectInHistory(project)
        
        print("✅ Arquivo '\(file.displayName)' adicionado ao projeto '\(project.name)'")
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
        guard var project = activeProject else {
            print("❌ Nenhum projeto ativo para remover arquivo")
            return
        }
        
        if let fileIndex = project.additionalFiles.firstIndex(where: { $0.id == fileId }) {
            let removedFile = project.additionalFiles[fileIndex]
            project.additionalFiles.remove(at: fileIndex)
            activeProject = project
            saveActiveProject()
            updateProjectInHistory(project)
            
            print("🗑️ Arquivo '\(removedFile.displayName)' removido do projeto '\(project.name)'")
        } else {
            print("❌ Arquivo com ID \(fileId) não encontrado")
        }
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
    
    // 🔥 FIREBASE TODO: Esta função vira loadFromFirestore() - GRANDE MUDANÇA!
    // 🔥   - Substituir UserDefaults por Firestore query
    // 🔥   - Filtrar por userId do usuário logado
    // 🔥   - Adicionar listener para sync em tempo real
    // 🔥   - Error handling para falhas de network
    private func loadProjects() {
        print("📱 Carregando projetos salvos...")
        
        // 🔥 FIREBASE TODO: Substituir por:
        // let db = Firestore.firestore()
        // db.collection("projects")
        //   .whereField("userId", isEqualTo: currentUserId)
        //   .addSnapshotListener { snapshot, error in ... }
        
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
    
    // 🔥 FIREBASE TODO: Esta função vira saveToFirestore() - MUDANÇA IMPORTANTE!
    // 🔥   - Em vez de JSON local, salvar cada projeto no Firestore
    // 🔥   - Adicionar userId em cada documento
    // 🔥   - Usar batch writes para performance
    // 🔥   - Error handling para falhas de upload
    private func saveProjects() {
        print("💾 Salvando \(projects.count) projetos...")
        
        // 🔥 FIREBASE TODO: Substituir por:
        // let db = Firestore.firestore()
        // let batch = db.batch()
        // for project in projects {
        //     let docRef = db.collection("projects").document(project.id.uuidString)
        //     batch.setData(project.firestoreData, forDocument: docRef)
        // }
        // batch.commit { error in ... }
        
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
    
    // MARK: - Active Project Persistence
    private func saveActiveProject() {
        guard let project = activeProject else {
            userDefaults.removeObject(forKey: activeProjectKey)
            return
        }
        
        do {
            let data = try JSONEncoder().encode(project)
            userDefaults.set(data, forKey: activeProjectKey)
            print("💾 Projeto ativo salvo: \(project.name)")
        } catch {
            print("❌ Erro ao salvar projeto ativo: \(error.localizedDescription)")
        }
    }
    
    private func loadActiveProject() {
        guard let data = userDefaults.data(forKey: activeProjectKey) else {
            print("📱 Nenhum projeto ativo encontrado")
            return
        }
        
        do {
            let project = try JSONDecoder().decode(ProjectModel.self, from: data)
            activeProject = project
            print("✅ Projeto ativo carregado: \(project.name)")
        } catch {
            print("❌ Erro ao carregar projeto ativo: \(error.localizedDescription)")
        }
    }
    
    private func updateProjectInHistory(_ project: ProjectModel) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
        } else {
            projects.append(project)
        }
        saveProjects()
    }
    
    func addMockProjects() {
        let mockFiles1 = [
            ProjectFile(
                name: "Storyboard Cena 1",
                fileName: "storyboard_cena1.jpg",
                fileType: .jpg,
                fileSize: "2.3 MB",
                localURL: nil // Mock file
            ),
            ProjectFile(
                name: "Cronograma de Filmagem",
                fileName: "cronograma.docx",
                fileType: .docx,
                fileSize: "156 KB",
                localURL: nil // Mock file
            )
        ]
        
        let mockFiles2 = [
            ProjectFile(
                name: "Referências Visuais",
                fileName: "referencias.zip",
                fileType: .zip,
                fileSize: "5.2 MB",
                localURL: nil // Mock file
            ),
            ProjectFile(
                name: "Orçamento",
                fileName: "orcamento.pdf",
                fileType: .pdf,
                fileSize: "890 KB",
                localURL: nil // Mock file
            ),
            ProjectFile(
                name: "Playlist Trilha Sonora",
                fileName: "trilha_sonora.m4a",
                fileType: .m4a,
                fileSize: "12.4 MB",
                localURL: nil // Mock file
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

// 🔥 FIREBASE TODO: RESUMO GERAL DAS MUDANÇAS NO PROJECTMANAGER:
// 🔥 
// 🔥 1. IMPORTS NECESSÁRIOS:
// 🔥    import FirebaseFirestore
// 🔥    import FirebaseAuth
// 🔥    
// 🔥 2. PROPRIEDADES A ADICIONAR:
// 🔥    private let db = Firestore.firestore()
// 🔥    private var currentUserId: String? { Auth.auth().currentUser?.uid }
// 🔥    private var listener: ListenerRegistration?
// 🔥    
// 🔥 3. FUNÇÕES A MODIFICAR:
// 🔥    loadProjects() → loadFromFirestore() (com listener em tempo real)
// 🔥    saveProjects() → saveToFirestore() (batch writes)
// 🔥    addProject() → adicionar userId automaticamente
// 🔥    removeProject() → deletar do Firestore também
// 🔥    
// 🔥 4. NOVAS FUNÇÕES A CRIAR:
// 🔥    func signOut() { // limpar listener e dados locais }
// 🔥    func handleAuthStateChange() { // recarregar quando user mudar }
// 🔥    
// 🔥 5. ESTRUTURA FIRESTORE:
// 🔥    Collection: "projects"
// 🔥    Document ID: project.id.uuidString  
// 🔥    Fields: code, director, name, userId, files[], callSheets[], etc
// 🔥    
// 🔥 ➡️ O RESTO DO CÓDIGO CONTINUA FUNCIONANDO IGUAL!
