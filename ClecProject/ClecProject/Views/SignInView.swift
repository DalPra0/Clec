//
//  SignInView.swift
//  ClecProject
//
//  Pixel-Perfect Figma Implementation - Tela Completa de Criar Conta
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var showPassword = false
    @State private var showLogin = false
    
    var allFieldsFilled: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background - Automático: Azul no light, escuro no dark
                    Color("DesignSystem/Background")
                        .ignoresSafeArea()
                    
                    // Elementos cinematográficos decorativos - POSIÇÕES EXATAS DO FIGMA
                    // Personagem central com documento - POSIÇÃO PRINCIPAL DO FIGMA
                    Image("AssetPersonagemSegurandoOrdemdoDia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 244, height: 259) // Tamanho do Figma
                        .rotationEffect(.degrees(6.25)) // Rotação diferente da tela de login
                        .position(
                            x: geometry.size.width * 0.5,  // Centro horizontal
                            y: geometry.size.height * 0.28 // 28% da altura da tela
                        )
                    
                    // Rolo superior direita - TAMANHO MENOR
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120) // MENOR - tamanho correto do Figma
                        .rotationEffect(.degrees(13.142)) // Rotação exata
                        .position(
                            x: geometry.size.width * 0.85, // 85% da largura
                            y: geometry.size.height * 0.18  // 18% da altura
                        )
                    
                    // Rolo superior esquerda - TAMANHO MENOR  
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110) // MENOR - tamanho correto do Figma
                        .rotationEffect(.degrees(13.142)) // Rotação igual
                        .position(
                            x: geometry.size.width * 0.15, // 15% da largura
                            y: geometry.size.height * 0.18  // 18% da altura
                        )
                    
                    // CARD INFERIOR - Layout na parte inferior da tela
                    VStack {
                        Spacer() // Empurra o card para baixo
                        
                        VStack(spacing: 24) { // Spacing interno conforme Figma
                            // TÍTULO - Especificações exatas do Figma
                            Text("Seja bem-vindo")
                                .font(.system(size: 28, weight: .bold)) // SF Pro Bold, 28px
                                .foregroundColor(Color("DesignSystem/TextPrimary")) // Cor automática
                                .tracking(0.38) // Letter spacing do Figma
                                .frame(maxWidth: .infinity, alignment: .leading) // Alinhado à esquerda
                                .padding(.top, 32) // Espaço do topo exato
                                
                            // CAMPOS DE INPUT
                            VStack(spacing: 24) { // Spacing entre campos conforme Figma
                                // Campo Nome
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Nome")
                                        .font(.system(size: 15, weight: .semibold)) // SF Pro Semibold, 15px
                                        .foregroundColor(Color("DesignSystem/TextPrimary"))
                                        .tracking(-0.23) // Letter spacing do Figma
                                    
                                    TextField("", text: $name, prompt: 
                                        Text("Insira o seu nome")
                                            .foregroundColor(Color("DesignSystem/Placeholder")) // Placeholder color
                                    )
                                    .font(.system(size: 15, weight: .regular)) // SF Pro Regular, 15px
                                    .foregroundColor(Color("DesignSystem/TextPrimary"))
                                    .tracking(-0.23)
                                    .padding(16) // Padding exato do Figma
                                    .frame(height: 52) // Height calculado baseado no Figma
                                    .background(Color("DesignSystem/InputBackground")) // Background automático
                                    .cornerRadius(8) // Border radius do Figma
                                    .autocorrectionDisabled()
                                }
                                
                                // Campo E-mail
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("E-mail")
                                        .font(.system(size: 15, weight: .semibold)) // SF Pro Semibold, 15px
                                        .foregroundColor(Color("DesignSystem/TextPrimary"))
                                        .tracking(-0.23) // Letter spacing do Figma
                                    
                                    TextField("", text: $email, prompt: 
                                        Text("Insira o seu e-mail")
                                            .foregroundColor(Color("DesignSystem/Placeholder")) // Placeholder color
                                    )
                                    .font(.system(size: 15, weight: .regular)) // SF Pro Regular, 15px
                                    .foregroundColor(Color("DesignSystem/TextPrimary"))
                                    .tracking(-0.23)
                                    .padding(16) // Padding exato do Figma
                                    .frame(height: 52) // Height calculado baseado no Figma
                                    .background(Color("DesignSystem/InputBackground")) // Background automático
                                    .cornerRadius(8) // Border radius do Figma
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                                }
                                
                                // Campo Senha
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Senha")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(Color("DesignSystem/TextPrimary"))
                                            .tracking(-0.23)
                                        
                                        Spacer()
                                        
                                        Button("Recuperar senha") {
                                            // Ação de recuperar senha
                                        }
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color("DesignSystem/Primary")) // Cor laranja automática
                                        .tracking(-0.23)
                                    }
                                    
                                    HStack {
                                        if showPassword {
                                            TextField("", text: $password, prompt: 
                                                Text("Insira a sua senha")
                                                    .foregroundColor(Color("DesignSystem/Placeholder"))
                                            )
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color("DesignSystem/TextPrimary"))
                                            .tracking(-0.23)
                                        } else {
                                            SecureField("", text: $password, prompt: 
                                                Text("Insira a sua senha")
                                                    .foregroundColor(Color("DesignSystem/Placeholder"))
                                            )
                                            .font(.system(size: 15, weight: .regular))
                                            .foregroundColor(Color("DesignSystem/TextPrimary"))
                                            .tracking(-0.23)
                                        }
                                        
                                        Button(action: {
                                            showPassword.toggle()
                                        }) {
                                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                                .font(.system(size: 15))
                                                .foregroundColor(Color("DesignSystem/Placeholder"))
                                        }
                                    }
                                    .padding(16)
                                    .frame(height: 52)
                                    .background(Color("DesignSystem/InputBackground"))
                                    .cornerRadius(8)
                                }
                            }
                            .frame(width: 370) // Width exato dos campos no Figma
                            
                            // BOTÕES
                            VStack(spacing: 16) { // Spacing conforme Figma
                                // Botão Confirmar
                                Button {
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                    signUp()
                                } label: {
                                    if authService.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(height: 20)
                                    } else {
                                        Text("Confirmar")
                                            .font(.system(size: 17, weight: .semibold)) // SF Pro Semibold, 17px
                                            .foregroundColor(Color("DesignSystem/OnPrimary")) // Cor do texto automática
                                            .tracking(-0.43) // Letter spacing
                                    }
                                }
                                .frame(width: 370) // Width exato
                                .frame(height: 50) // Height exato do Figma
                                .background(
                                    allFieldsFilled ? Color("DesignSystem/Primary") : Color.gray.opacity(0.3)
                                )
                                .cornerRadius(12) // Border radius do Figma
                                .disabled(!allFieldsFilled || authService.isLoading)
                                .buttonStyle(PlainButtonStyle())
                                
                                // Link para login - Text com cores diferentes
                                HStack(spacing: 0) {
                                    Text("Já tem uma conta? ")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color("DesignSystem/TextPrimary"))
                                        .tracking(-0.23)
                                    
                                    Button("Faça login") {
                                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                        impactFeedback.impactOccurred()
                                        showLogin = true
                                    }
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color("DesignSystem/Primary"))
                                    .tracking(-0.23)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .frame(maxWidth: .infinity) // Largura total disponível
                        .padding(.horizontal, 16) // Padding igual ao Figma
                        .padding(.bottom, 34) // Bottom padding para home indicator
                        .background(Color("DesignSystem/Surface")) // Background automático
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight])) // Bordas arredondadas apenas no topo
                    }
                }
            }
            .ignoresSafeArea(.all) // Ignora safe area para tela completa
            .alert("Sign Up Failed", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authService.errorMessage ?? "An unknown error occurred.")
            }
            .onChange(of: authService.errorMessage) {
                if authService.errorMessage != nil {
                    showAlert = true
                }
            }
            // Navegação automática será tratada pela tela pai
            .navigationDestination(isPresented: $showLogin) {
                LoginModalView()
            }
        }
    }
    
    private func signUp() {
        Task {
            await authService.signUp(withEmail: email, password: password)
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(AuthService())
}
