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
            GeometryReader { geometry in
                ZStack {
                    Color(hex: "#141414")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // PARTE SUPERIOR - PEQUENA (30% da tela)
                        VStack {
                            Spacer()
                            
                            Text("Bem vindo!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                                .onLongPressGesture {
                                    projectManager.addMockProjects()
                                    userManager.updateUserName("Lucas")
                                    
                                    if let firstProject = projectManager.projects.first {
                                        projectManager.setActiveProject(firstProject)
                                    }
                                    
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                }
                                .onTapGesture(count: 5) {
                                    projectManager.clearActiveProject()
                                    projectManager.clearAllProjects()
                                    userManager.resetToDefault()
                                    
                                    let notificationFeedback = UINotificationFeedbackGenerator()
                                    notificationFeedback.notificationOccurred(.warning)
                                }
                            
                            Text("Você pode escolher criar um projeto\nou entrar em um com código")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                            
                            Spacer()
                        }
                        .frame(height: geometry.size.height * 0.35) // 35% DA TELA
                        
                        // RETÂNGULO GRANDE - OCUPA O RESTO (70% da tela)
                        VStack(spacing: 0) {
                            // Handle visual
                            RoundedRectangle(cornerRadius: 2.5)
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 36, height: 5)
                                .padding(.top, 12)
                                .padding(.bottom, 24)
                            
                            VStack(spacing: 16) {
                                // Card Criar Projeto
                                Button(action: {
                                    showingCreateProject = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Criar um Projeto")
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text("Eu sou assistente\nde direção")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.white.opacity(0.9))
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        // SVG Claquete
                                        Image("Claquete")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                    }
                                    .padding(20)
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(hex: "#F85601"),
                                                        Color(hex: "#FF99DF")
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Card Join Projeto
                                Button(action: {
                                    showingJoinProject = true
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Você tem um código?")
                                                .font(.system(size: 20, weight: .semibold))
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text("Sou membro do set\nde produção")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.white.opacity(0.9))
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        // SVG Claquete
                                        Image("Claquete")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                    }
                                    .padding(20)
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color(hex: "#F85601"),
                                                        Color(hex: "#FF99DF")
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                        }
                        .frame(height: geometry.size.height * 0.65) // 65% DA TELA
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "#1C1C1E"))
                        )
                    }
                }
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

#Preview {
    InitialView()
        .environmentObject(ProjectManager())
        .environmentObject(UserManager())
}
