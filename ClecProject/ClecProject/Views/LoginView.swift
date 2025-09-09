//
//  LoginView.swift
//  ClecProject
//
//  Updated: Cleck! Design Implementation - Tela Inicial com Logo
//

import SwiftUI

struct LoginView: View {
    @State private var showLoginModal = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background preto
                Color.black
                    .ignoresSafeArea()
                
                // Elementos decorativos de cinema posicionados absolutamente
                GeometryReader { geometry in
                    // Câmera superior esquerda
                    Image("AssetPersonagemSegurandoCamera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .position(
                            x: geometry.size.width * 0.15,
                            y: geometry.size.height * 0.25
                        )
                    
                    // Rolo de filme superior direita
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .position(
                            x: geometry.size.width * 0.85,
                            y: geometry.size.height * 0.20
                        )
                    
                    // Claquete inferior esquerda
                    Image("AssetMaoSegurandoClaquete")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .position(
                            x: geometry.size.width * 0.20,
                            y: geometry.size.height * 0.75
                        )
                    
                    // Câmera laranja inferior direita
                    Image("AssetPersoagemSegurandoCameraLaranja")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130, height: 130)
                        .position(
                            x: geometry.size.width * 0.80,
                            y: geometry.size.height * 0.70
                        )
                    
                    // Rolo de filme menor (centro-esquerda)
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .position(
                            x: geometry.size.width * 0.10,
                            y: geometry.size.height * 0.50
                        )
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Logo central "cleck!" com explosão amarela
                    Image("CleckAssetComBalao")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .padding(.bottom, 40)
                    
                    Spacer()
                    
                    // Botões na parte inferior
                    VStack(spacing: 16) {
                        // Botão "Fazer login" - Laranja
                        Button {
                            showLoginModal = true
                        } label: {
                            Text("Fazer login")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color("PrimaryOrange"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Botão "Criar uma conta" - Preto com borda branca
                        Button {
                            showSignUp = true
                        } label: {
                            Text("Criar uma conta")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
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