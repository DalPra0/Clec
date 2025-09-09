//
//  InitialView.swift
//  ClecProject
//
//  LIGHT/DARK MODE AUTOMÁTICO - DESIGN PIXEL-PERFECT

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    @State private var showingCreateProject = false
    @State private var showingJoinProject = false
    @State private var tapCount = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // FUNDO AUTOMÁTICO (BRANCO NO LIGHT, PRETO NO DARK)
                Color("BackgroundMain")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // HEADER COM TÍTULO E SUBTÍTULO
                    VStack(spacing: 16) {
                        // Título principal
                        Text("Bem vindo!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("TextPrimary"))
                            .onTapGesture {
                                handleLogoTap()
                            }
                            .onLongPressGesture(minimumDuration: 1.0) {
                                handleLongPress()
                            }
                        
                        // Subtítulo
                        Text("Você pode escolher criar um projeto\nou entrar em um com código")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color("TextSecondary"))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                        .frame(height: 64)
                    
                    // CARDS PRINCIPAIS
                    VStack(spacing: 24) {
                        // CARD 1: CRIAR PROJETO
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            showingCreateProject = true
                        }) {
                            HStack(spacing: 0) {
                                // TEXTO À ESQUERDA
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Criar um Projeto")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(Color("PrimaryOrange"))
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("Eu sou assistente\nde direção")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color("TextPrimary"))
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(2)
                                }
                                
                                Spacer()
                                
                                // ILUSTRAÇÃO À DIREITA
                                Image("AssetMaoSegurandoClaqueteLaranja")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("CardBackground"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color("PrimaryOrange").opacity(0.3),
                                                        Color("PrimaryOrange").opacity(0.1)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // CARD 2: ENTRAR COM CÓDIGO
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            showingJoinProject = true
                        }) {
                            HStack(spacing: 0) {
                                // TEXTO À ESQUERDA
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Você tem\num código?")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(Color("PrimaryOrange"))
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(2)
                                    
                                    Text("Sou membro do\nset de produção")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color("TextPrimary"))
                                        .multilineTextAlignment(.leading)
                                        .lineSpacing(2)
                                }
                                
                                Spacer()
                                
                                // ILUSTRAÇÃO À DIREITA
                                Image("AssetPersoagemSegurandoCameraLaranja")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("CardBackground"))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color("PrimaryOrange").opacity(0.3),
                                                        Color("PrimaryOrange").opacity(0.1)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        // REMOVIDO: .preferredColorScheme(.dark) - AGORA É AUTOMÁTICO!
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
    
    // MARK: - Gesture Handlers
    
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

// For Xcode versions prior to 15, use this syntax instead:
/*
struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InitialView()
                .environmentObject(ProjectManager())
                .environmentObject(UserManager())
                .preferredColorScheme(.light)
            
            InitialView()
                .environmentObject(ProjectManager())
                .environmentObject(UserManager())
                .preferredColorScheme(.dark)
        }
    }
}
*/
