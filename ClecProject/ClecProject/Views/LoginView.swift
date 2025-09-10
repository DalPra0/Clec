//
//  LoginView.swift
//  ClecProject
//
//  Pixel-Perfect Figma Implementation - Tamanhos REAIS e Posições EXATAS
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingLoginView = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background - Automático Dark/Light Mode
                    Color("DesignSystem/Background")
                        .ignoresSafeArea()
                    
                    // Elementos cinematográficos decorativos - TAMANHOS REAIS DO FIGMA
                    
                    // Câmera superior esquerda - TAMANHO MÁXIMO igual ao Figma
                    Image("AssetPersonagemSegurandoCamera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 380, height: 340) // TAMANHO MÁXIMO - ajuste final
                        .rotationEffect(.degrees(-15))
                        .position(
                            x: geometry.size.width * 0.18,  // 18% da largura
                            y: geometry.size.height * 0.15  // 15% da altura
                        )
                    
                    // Rolo superior direita - GRANDE como no Figma
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 170) // MAIOR - tamanho real do Figma
                        .rotationEffect(.degrees(15))
                        .position(
                            x: geometry.size.width * 0.82,  // 82% da largura
                            y: geometry.size.height * 0.15  // 15% da altura
                        )
                    
                    // Logo central "CLECK!" - DOMINANTE como no Figma
                    Image(colorScheme == .dark ? "CleckAssetComBalao" : "CleckAssetComBalaoLaranja")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 380, height: 320) // MUITO MAIOR - dominante na tela
                        .position(
                            x: geometry.size.width * 0.5,   // Centro horizontal
                            y: geometry.size.height * 0.42  // 42% da altura - posição central
                        )
                    
                    // Rolo inferior esquerda - GRANDE como no Figma
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // MAIOR - visível no design
                        .rotationEffect(.degrees(15))
                        .position(
                            x: geometry.size.width * 0.15,  // 15% da largura
                            y: geometry.size.height * 0.68  // 68% da altura
                        )
                    
                    // Claquete inferior direita - TAMANHO MÁXIMO para encostar no balão
                    Image("AssetMaoSegurandoClaquete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 290) // TAMANHO MÁXIMO - ajuste final
                        .rotationEffect(.degrees(-10))
                        .position(
                            x: geometry.size.width * 0.85,  // 85% da largura
                            y: geometry.size.height * 0.65  // 65% - ENCOSTA na pontinha do balão
                        )
                    
                    // BOTÕES na parte inferior - SOBRE os elementos
                    VStack {
                        Spacer() // Empurra os botões para baixo
                        
                        VStack(spacing: 16) {
                            // Botão "Fazer login" - LARANJA SÓLIDO
                            Button {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                showingLoginView = true
                            } label: {
                                Text("Fazer login")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color("DesignSystem/OnPrimary"))
                                    .tracking(-0.43)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color("DesignSystem/Primary"))
                            .cornerRadius(12)
                            .buttonStyle(PlainButtonStyle())
                            
                            // Botão "Criar uma conta" - OUTLINE ADAPTÁVEL
                            Button {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                showSignUp = true
                            } label: {
                                Text("Criar uma conta")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(Color("DesignSystem/ButtonSecondaryText"))
                                    .tracking(-0.43)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color("DesignSystem/Primary"), lineWidth: 2)
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                        
                        // Home Indicator
                        Rectangle()
                            .fill(Color("DesignSystem/HomeIndicator"))
                            .frame(width: 134, height: 5)
                            .cornerRadius(3)
                            .padding(.bottom, 8)
                    }
                }
            }
            .ignoresSafeArea(.all)
            .navigationDestination(isPresented: $showingLoginView) {
                LoginModalView()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignInView()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthService())
}
