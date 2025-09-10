//
//  InitialView.swift
//  ClecProject
//

import SwiftUI

struct InitialView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
    @State private var showingCreateProject = false
    @State private var showingJoinProject = false
    @State private var tapCount = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("DesignSystem/Background")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                        .padding(.top, 20)
                        .padding(.bottom, 50)
                    
                    cardContainerView
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
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Bem vindo!")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .onTapGesture(perform: handleLogoTap)
                .onLongPressGesture(minimumDuration: 1.0, perform: handleLongPress)
            
            Text("Você pode escolher criar um projeto\nou entrar em um com código")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .tracking(-0.43)
        }
        .padding(.horizontal, 32)
    }
    
    private var cardContainerView: some View {
        VStack(spacing: 27) {
            InitialActionCard(
                title: "Criar um Projeto",
                subtitle: "Eu sou assistente\nde direção",
                imageName: "AssetMaoSegurandoClaqueteLaranja",
                imageWidth: 187,
                action: { showingCreateProject = true }
            )
            
            InitialActionCard(
                title: "Você tem\num código?",
                subtitle: "Sou membro do\nset de produção",
                imageName: "AssetPersoagemSegurandoCameraLaranja",
                imageWidth: 200,
                action: { showingJoinProject = true }
            )
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 34)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 24, bottomLeadingRadius: 0,
                bottomTrailingRadius: 0, topTrailingRadius: 24
            )
            .fill(colorScheme == .light ? Color(hex: "#f5f6f6") : Color(hex: "#1b1c1e"))
            .ignoresSafeArea(edges: .bottom)
        )
    }

    private func handleLogoTap() {
        tapCount += 1
        if tapCount >= 5 {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
            userManager.resetToDefault()
            tapCount = 0
            print("🗑️ Dados do usuário foram resetados!")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            tapCount = 0
        }
    }
    
    private func handleLongPress() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
        print("🎬 Long press detectado - funcionalidade preservada!")
    }
}


#Preview {
    InitialView()
        .environmentObject(ProjectManager())
        .environmentObject(UserManager())
}
