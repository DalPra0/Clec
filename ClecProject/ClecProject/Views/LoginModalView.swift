//
//  LoginModalView.swift
//  ClecProject
//
//  Pixel-Perfect Figma Implementation - Asset Correto (Ordem do Dia)
//

import SwiftUI

struct LoginModalView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authService: AuthService
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var showSignUp = false
    @State private var showPassword = false
    
    var allFieldsFilled: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background - Automático: Azul no light, escuro no dark
                    Color("DesignSystem/Background")
                        .ignoresSafeArea()
                        .dismissKeyboardOnTap() // Dismiss keyboard when tapping background
                    
                    // BONECO SEGURANDO ORDEM DO DIA - ASSET CORRETO
                    Image("AssetPersonagemSegurandoOrdemdoDia")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 320, height: 280) // Tamanho maior como no Figma
                        .rotationEffect(.degrees(-4.265)) // Rotação correta
                        .position(
                            x: geometry.size.width * 0.5,  // Centro horizontal
                            y: geometry.size.height * 0.30 // 30% da altura da tela
                        )
                    
                    // Rolo superior direita - TAMANHO MENOR
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120) // MENOR - tamanho correto do Figma
                        .rotationEffect(.degrees(13.142))
                        .position(
                            x: geometry.size.width * 0.85,
                            y: geometry.size.height * 0.15
                        )
                    
                    // Rolo inferior esquerda - TAMANHO MENOR
                    Image("AssetRoloFIlme")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110) // MENOR - tamanho correto do Figma
                        .rotationEffect(.degrees(13.142))
                        .position(
                            x: geometry.size.width * 0.15,
                            y: geometry.size.height * 0.45
                        )
                    
                    // CARD DE LOGIN na parte inferior
                    VStack {
                        Spacer() // Empurra o card para baixo
                        
                        VStack(spacing: 24) {
                            // TÍTULO
                            Text("Bem-vindo de volta")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color("DesignSystem/TextPrimary"))
                                .tracking(0.38)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 32)
                            
                            // CAMPOS DE INPUT
                            VStack(spacing: 24) {
                                // Campo E-mail
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("E-mail")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(Color("DesignSystem/TextPrimary"))
                                        .tracking(-0.23)
                                    
                                    TextField("", text: $email, prompt: 
                                        Text("Insira o seu e-mail")
                                            .foregroundColor(Color("DesignSystem/Placeholder"))
                                    )
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color("DesignSystem/TextPrimary"))
                                    .tracking(-0.23)
                                    .padding(16)
                                    .frame(height: 52)
                                    .background(Color("DesignSystem/InputBackground"))
                                    .cornerRadius(8)
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
                                        .foregroundColor(Color("DesignSystem/Primary"))
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
                            .frame(width: 370)
                            
                            // BOTÕES
                            VStack(spacing: 16) {
                                // Botão Confirmar
                                Button {
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                    signIn()
                                } label: {
                                    if authService.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .frame(height: 20)
                                    } else {
                                        Text("Confirmar")
                                            .font(.system(size: 17, weight: .semibold))
                                            .foregroundColor(Color("DesignSystem/OnPrimary"))
                                            .tracking(-0.43)
                                    }
                                }
                                .frame(width: 370)
                                .frame(height: 50)
                                .background(
                                    allFieldsFilled ? Color("DesignSystem/Primary") : Color.gray.opacity(0.3)
                                )
                                .cornerRadius(12)
                                .disabled(!allFieldsFilled || authService.isLoading)
                                .buttonStyle(PlainButtonStyle())
                                
                                // Link para cadastro
                                HStack(spacing: 0) {
                                    Text("Não tem uma conta? ")
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(Color("DesignSystem/TextPrimary"))
                                        .tracking(-0.23)
                                    
                                    Button("Cadastre-se") {
                                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                        impactFeedback.impactOccurred()
                                        showSignUp = true
                                    }
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(Color("DesignSystem/Primary"))
                                    .tracking(-0.23)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 34)
                        .background(Color("DesignSystem/Surface"))
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                    }
                }
            }
            .ignoresSafeArea(.all)
            .alert("Login Failed", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authService.errorMessage ?? "An unknown error occurred.")
            }
            .onChange(of: authService.errorMessage) {
                if authService.errorMessage != nil {
                    showAlert = true
                }
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignInView()
            }
        }
    }
    
    private func signIn() {
        Task {
            await authService.signIn(withEmail: email, password: password)
        }
    }
}

#Preview {
    LoginModalView()
        .environmentObject(AuthService())
}
