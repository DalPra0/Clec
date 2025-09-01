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
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer(minLength: 80)
            
            VStack(spacing: 16) {
                Text("CLÉQUI!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .onLongPressGesture {
                        projectManager.addMockProjects()
                        
                        userManager.updateUserName("Lucas")
                        
                        // Testar sistema de arquivos
                        #if DEBUG
                        FilesSystemTest.runAllTests()
                        #endif
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }
                    .onTapGesture(count: 5) {
                        projectManager.clearAllProjects()
                        userManager.resetToDefault()
                        
                        let notificationFeedback = UINotificationFeedbackGenerator()
                        notificationFeedback.notificationOccurred(.warning)
                        
                        print("🧿 Todos os dados foram limpos - volta para tela inicial")
                    }
                
                Text("Bem vindo!")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Você pode escolher criar um projeto\nou entrar em um com código")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            Spacer(minLength: 60)
            
            VStack(spacing: 16) {
                NavigationLink(destination:
                    CreateProjectView()
                        .environmentObject(projectManager)
                ) {
                    InitialActionCard(
                        title: "Criar",
                        subtitle: "Eu sou assistente de direção"
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination:
                    JoinProjectView()
                        .environmentObject(projectManager)
                ) {
                    InitialActionCard(
                        title: "Você tem código?",
                        subtitle: "Clique"
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 32)
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
        .preferredColorScheme(.light)
    }
}

#Preview {
    NavigationView {
        InitialView()
            .environmentObject(ProjectManager())
            .environmentObject(UserManager())
    }
}
