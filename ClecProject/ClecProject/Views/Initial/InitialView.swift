//
//  InitialView.swift
//  ClecProject
//
//  PIXEL-PERFECT FIGMA - Tela "Bem vindo!" Idêntica ao Design
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
            GeometryReader { geometry in
                ZStack {
                    // FUNDO AUTOMÁTICO - Azul no light, preto no dark
                    Color("DesignSystem/Background")
                        .ignoresSafeArea()
                    
                    // ASSETS CINEMATOGRÁFICOS DECORATIVOS - igual ao Figma
                    
                    // Boneco com câmera - superior esquerda
                    Image("AssetPersonagemSegurandoCamera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 180)
                        .rotationEffect(.degrees(-15))
                        .position(
                            x: geometry.size.width * 0.15,
                            y: geometry.size.height * 0.15
                        )
                    
                    // Rolos de filme - decorativos
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(15))
                        .position(
                            x: geometry.size.width * 0.85,
                            y: geometry.size.height * 0.15
                        )
                    
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-20))
                        .position(
                            x: geometry.size.width * 0.15,
                            y: geometry.size.height * 0.75
                        )
                    
                    // LAYOUT PRINCIPAL
                    VStack(spacing: 0) {
                        // HEADER - exato do Figma
                        VStack(spacing: 16) {
                            Text("Bem vindo!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color("DesignSystem/TextPrimary"))
                                .onTapGesture {
                                    handleLogoTap()
                                }
                                .onLongPressGesture(minimumDuration: 1.0) {
                                    handleLongPress()
                                }
                            
                            Text("Você pode escolher criar um projeto\nou entrar em um com código")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(Color("DesignSystem/TextPrimary"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }
                        .padding(.top, 80)
                        .padding(.horizontal, 32)
                        
                        Spacer()
                        
                        // CARDS GRANDES - exatos do Figma
                        VStack(spacing: 53) {
                            // CARD 1: CRIAR PROJETO
                            Button(action: {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                showingCreateProject = true
                            }) {
                                HStack(spacing: 13) {
                                    // TEXTO À ESQUERDA
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Criar um Projeto")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(Color("DesignSystem/Primary"))
                                            .tracking(-0.45)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("Eu sou assistente\nde direção")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(colorScheme == .dark ? Color("DesignSystem/TextPrimary") : Color("DesignSystem/TextPrimary"))
                                            .tracking(-0.31)
                                            .multilineTextAlignment(.leading)
                                            .lineSpacing(1)
                                            .padding(.top, 6)
                                    }
                                    
                                    Spacer()
                                    
                                    // ASSET À DIREITA - claquete com rotação
                                    Image("AssetMaoSegurandoClaqueteLaranja")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 187, height: 177)
                                        .rotationEffect(.degrees(180))
                                        .scaleEffect(x: -1, y: -1)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 24)
                                .frame(height: 156)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("DesignSystem/Surface"))
                                        .shadow(
                                            color: Color.black.opacity(0.25),
                                            radius: 4,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // CARD 2: CÓDIGO
                            Button(action: {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                showingJoinProject = true
                            }) {
                                HStack(spacing: 0) {
                                    // TEXTO À ESQUERDA
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text("Você tem\num código?")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(Color("DesignSystem/Primary"))
                                            .tracking(-0.45)
                                            .multilineTextAlignment(.leading)
                                            .lineSpacing(1)
                                        
                                        Text("Sou membro do\nset de produção")
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(colorScheme == .dark ? Color("DesignSystem/TextPrimary") : Color("DesignSystem/TextPrimary"))
                                            .tracking(-0.31)
                                            .multilineTextAlignment(.leading)
                                            .lineSpacing(1)
                                            .padding(.top, 6)
                                    }
                                    
                                    Spacer()
                                    
                                    // ASSET À DIREITA - câmera com rotação
                                    Image("AssetPersoagemSegurandoCameraLaranja")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 293, height: 262)
                                        .rotationEffect(.degrees(180))
                                        .scaleEffect(x: -1, y: -1)
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 24)
                                .frame(height: 156)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color("DesignSystem/Surface"))
                                        .shadow(
                                            color: Color.black.opacity(0.25),
                                            radius: 4,
                                            x: 0,
                                            y: 4
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(width: 327) // Width exato do Figma
                        
                        Spacer()
                        Spacer()
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
