//
//  SettingsSection.swift
//  ClecProject
//
//  Enhanced functional settings section
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsSection: View {
    let project: ProjectModel?
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var showingEditProfile = false
    @State private var showingProjectSettings = false
    @State private var showingShareSheet = false
    @State private var showingLeaveProjectAlert = false
    @State private var showingDeleteProjectAlert = false
    
    // Computed property to check if current user is project owner
    private var isProjectOwner: Bool {
        guard let project = project,
              let userId = Auth.auth().currentUser?.uid else { return false }
        return project.ownerId == userId
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                profileSection
                
                if project != nil {
                    projectSection
                }
                
                appSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
                .environmentObject(userManager)
        }
        .sheet(isPresented: $showingProjectSettings) {
            if let project = project {
                ProjectSettingsView(project: project)
                    .environmentObject(projectManager)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let project = project {
                ShareProjectView(project: project)
            }
        }
        .alert("Sair do Projeto", isPresented: $showingLeaveProjectAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Sair", role: .destructive) {
                leaveProject()
            }
        } message: {
            Text("Tem certeza que deseja sair do projeto \"\(project?.name ?? "")\"?")
        }
        .alert("Excluir Projeto", isPresented: $showingDeleteProjectAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Excluir", role: .destructive) {
                deleteProject()
            }
        } message: {
            Text("Esta ação não pode ser desfeita. Tem certeza que deseja excluir o projeto \"\(project?.name ?? "")\"?")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Text("Configurações")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Perfil")
            
            SettingsRow(
                icon: "person.crop.circle",
                title: "Editar Perfil",
                subtitle: userManager.userName,
                action: { showingEditProfile = true }
            )
        }
    }
    
    // MARK: - Project Section
    private var projectSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Projeto")
            
            // Project Settings (only for owner)
            if isProjectOwner {
                SettingsRow(
                    icon: "film",
                    title: "Configurações do Projeto",
                    subtitle: project?.name ?? "",
                    action: { showingProjectSettings = true }
                )
            } else {
                SettingsRow(
                    icon: "film",
                    title: "Detalhes do Projeto",
                    subtitle: project?.name ?? "",
                    isDisabled: true,
                    action: { /* Disabled - no action */ }
                )
            }
            
            // Share Project
            SettingsRow(
                icon: "square.and.arrow.up",
                title: "Compartilhar Projeto",
                subtitle: "Código: \(project?.code ?? "----")",
                action: { showingShareSheet = true }
            )
            
            // Members
            SettingsRow(
                icon: "person.2",
                title: "Membros da Equipe",
                subtitle: "\(project?.members.count ?? 0) membro(s)",
                action: { /* TODO: Show members view */ }
            )
            
            // Leave/Delete Project
            if isProjectOwner {
                SettingsRow(
                    icon: "trash",
                    title: "Excluir Projeto",
                    subtitle: "Esta ação não pode ser desfeita",
                    isDestructive: true,
                    action: { showingDeleteProjectAlert = true }
                )
            } else {
                SettingsRow(
                    icon: "arrow.left.square",
                    title: "Sair do Projeto",
                    subtitle: "Você será removido da equipe",
                    isDestructive: true,
                    action: { showingLeaveProjectAlert = true }
                )
            }
        }
    }
    
    // MARK: - App Section
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("App")
            
            SettingsRow(
                icon: "bell",
                title: "Notificações",
                subtitle: "Configurar alertas",
                action: { /* TODO: Show notifications settings */ }
            )
            
            SettingsRow(
                icon: "paintbrush",
                title: "Aparência",
                subtitle: "Tema escuro",
                action: { /* TODO: Show appearance settings */ }
            )
            
            SettingsRow(
                icon: "questionmark.circle",
                title: "Ajuda e Suporte",
                subtitle: "FAQ, contato",
                action: { /* TODO: Show help */ }
            )
            
            SettingsRow(
                icon: "info.circle",
                title: "Sobre o App",
                subtitle: "Versão 1.0.0",
                action: { /* TODO: Show about */ }
            )
        }
    }
    
    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.white)
            .padding(.top, 8)
    }
    
    // MARK: - Actions
    private func leaveProject() {
        guard let project = project else { return }
        
        print("🚪 Leaving project: \(project.name)")
        
        projectManager.leaveProject(project) { success in
            if success {
                // Haptic feedback
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
            } else {
                // TODO: Show error alert
                print("❌ Failed to leave project")
            }
        }
    }
    
    private func deleteProject() {
        guard let project = project else { return }
        
        print("🗑️ Deleting project: \(project.name)")
        projectManager.removeProject(project)
        
        // Reset active project
        projectManager.setActiveProject(nil)
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
}

// MARK: - Settings Row Component
struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var isDestructive: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(iconBackgroundColor)
                    )
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(titleColor)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(subtitleColor)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Arrow (only if not disabled)
                if !isDisabled {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("TextSecondary"))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("CardBackground"))
                    .opacity(isDisabled ? 0.6 : 1.0)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
    
    private var iconColor: Color {
        if isDisabled {
            return Color("TextSecondary")
        } else if isDestructive {
            return .red
        } else {
            return Color("PrimaryOrange")
        }
    }
    
    private var iconBackgroundColor: Color {
        if isDisabled {
            return Color("CardBackground")
        } else if isDestructive {
            return Color.red.opacity(0.15)
        } else {
            return Color("PrimaryOrange").opacity(0.15)
        }
    }
    
    private var titleColor: Color {
        if isDisabled {
            return Color("TextSecondary")
        } else if isDestructive {
            return .red
        } else {
            return .white
        }
    }
    
    private var subtitleColor: Color {
        if isDisabled {
            return Color("TextSecondary").opacity(0.7)
        } else {
            return Color("TextSecondary")
        }
    }
}

#Preview {
    SettingsSection(project: nil)
        .background(Color("BackgroundDark"))
        .environmentObject(UserManager())
        .environmentObject(ProjectManager())
}
