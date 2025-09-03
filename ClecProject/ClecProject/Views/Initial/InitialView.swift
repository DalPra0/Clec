//
//  InitialView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    @State private var showingCreateProject = false
    @State private var showingJoinProject = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    welcomeSection
                    
                    Spacer()
                    
                    actionCards
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateProject) {
            CreateProjectView(onProjectCreated: { project in
                projectManager.setActiveProject(project)
                showingCreateProject = false
            })
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
        .sheet(isPresented: $showingJoinProject) {
            JoinProjectView(onProjectJoined: { project in
                projectManager.setActiveProject(project)
                showingJoinProject = false
            })
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
    }
    
    private var welcomeSection: some View {
        VStack(spacing: 16) {
            Spacer(minLength: 100)
            
            // Logo/Title
            Text("CLÉCQUI!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .onLongPressGesture {
                    // Long press para adicionar projetos mock e ativar o primeiro
                    projectManager.addMockProjects()
                    userManager.updateUserName("Lucas")
                    
                    // Definir primeiro projeto como ativo
                    if let firstProject = projectManager.projects.first {
                        projectManager.setActiveProject(firstProject)
                    }
                    
                    #if DEBUG
                    FilesSystemTest.runAllTests()
                    #endif
                    
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }
                .onTapGesture(count: 5) {
                    // 5 taps para limpar tudo
                    projectManager.clearActiveProject()
                    projectManager.clearAllProjects()
                    userManager.resetToDefault()
                    
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.warning)
                    
                    print("🧿 Todos os dados foram limpos - volta para tela inicial")
                }
            
            Text("Bem vindo!")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Você pode escolher criar um projeto\nou entrar em um com código")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
    }
    
    private var actionCards: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingCreateProject = true
            }) {
                ActionCard(
                    title: "Criar um Projeto",
                    subtitle: "Eu sou assistente\nde direção",
                    gradientColors: [Color.purple, Color.blue]
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                showingJoinProject = true
            }) {
                ActionCard(
                    title: "Você tem um código?",
                    subtitle: "Sou membro do set\nde produção",
                    gradientColors: [Color.purple, Color.blue]
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct ActionCard: View {
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Geometric illustration placeholder
            GeometricIllustration()
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct GeometricIllustration: View {
    var body: some View {
        ZStack {
            // Background shapes
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.2))
                .frame(width: 60, height: 40)
                .rotationEffect(.degrees(15))
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.15))
                .frame(width: 40, height: 30)
                .rotationEffect(.degrees(-10))
                .offset(x: 10, y: -5)
            
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 20, height: 20)
                .offset(x: -15, y: 15)
        }
        .frame(width: 80, height: 80)
    }
}

// Preview com mock data
#Preview {
    InitialView()
        .environmentObject(ProjectManager())
        .environmentObject(UserManager())
}
