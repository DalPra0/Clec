//
//  LoginView.swift
//  ClecProject
//
//  Updated: Pixel-Perfect Figma Implementation
//

import SwiftUI

struct LoginView: View {
    @State private var showLoginModal = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background - Cor exata do Figma
                Color(hex: "#060606")
                    .ignoresSafeArea()
                
                // Elementos decorativos de cinema posicionados como no Figma
                GeometryReader { geometry in
                    // Asset 11 - Câmera principal (superior esquerda) - MOVIDO PARA CIMA
                    Image("AssetPersonagemSegurandoCamera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 250)
                        .rotationEffect(.degrees(-15))
                        .position(
                            x: geometry.size.width * 0.10,
                            y: geometry.size.height * 0.08  // MAIS PARA CIMA (era 0.15)
                        )
                    
                    // Asset 17 - Rolo superior direita - MOVIDO PARA CIMA
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .rotationEffect(.degrees(13))
                        .position(
                            x: geometry.size.width * 0.85,
                            y: geometry.size.height * 0.10  // MAIS PARA CIMA (era 0.18)
                        )
                    
                    // Asset 16 - Claquete inferior direita - MOVIDO PARA CIMA
                    Image("AssetMaoSegurandoClaquete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 280)
                        .rotationEffect(.degrees(-3))
                        .position(
                            x: geometry.size.width * 0.75,
                            y: geometry.size.height * 0.50  // MAIS PARA CIMA (era 0.65)
                        )
                    
                    // Asset 17 copy - Rolo inferior esquerda - MOVIDO PARA CIMA
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(13))
                        .position(
                            x: geometry.size.width * 0.05,
                            y: geometry.size.height * 0.55  // MAIS PARA CIMA (era 0.70)
                        )
                }
                
                VStack(spacing: 0) {
                    // Spacer pequeno - logo mais centrado mas um pouco mais alto
                    Spacer(minLength: 40)
                    
                    // Logo central "cleck!" - POSICIONADO PARA CRIAR ESPAÇO LIMPO EMBAIXO
                    Image("CleckAssetComBalao")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 240)
                        .padding(.bottom, 40) // Mais espaço embaixo para separar dos botões
                    
                    // Spacer grande para criar área limpa para os botões
                    Spacer(minLength: 120)
                    
                    // Botões na parte inferior - Especificações exatas do Figma
                    VStack(spacing: 24) { // Spacing exato do Figma
                        // Botão "Fazer login" - Laranja
                        Button {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            showLoginModal = true
                        } label: {
                            Text("Fazer login")
                                .font(.system(size: 17, weight: .semibold)) // Font size exato do Figma
                                .foregroundColor(.white)
                                .tracking(-0.43) // Letter spacing do Figma
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 12) // Border radius exato
                                        .fill(Color(hex: "#f85601")) // Cor exata do Figma
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Botão "Criar uma conta" - Outline laranja (NÃO branco!)
                        Button {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                            showSignUp = true
                        } label: {
                            Text("Criar uma conta")
                                .font(.system(size: 17, weight: .semibold)) // Font size exato do Figma
                                .foregroundColor(.white)
                                .tracking(-0.43) // Letter spacing do Figma
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "#f85601"), lineWidth: 1) // Borda LARANJA, não branca!
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(width: 370) // Width exato do Figma
                    .padding(.bottom, 60) // Padding menor para manter botões na área limpa
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showLoginModal) {
                LoginModalView()
                    .presentationDetents([.height(450)])
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
