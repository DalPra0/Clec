//
//  LoginModalView.swift
//  ClecProject
//
//  Cleck! Design Implementation - Modal de Login
//

import SwiftUI

struct LoginModalView: View {
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var showSignUp = false
    
    var allFieldsFilled: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background escuro
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Título
                    VStack(alignment: .leading, spacing: 32) {
                        Text("Bem-vindo de volta")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 20) {
                            // Campo E-mail
                            VStack(alignment: .leading, spacing: 8) {
                                Text("E-mail")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                TextField("Insira o seu e-mail", text: $email)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                            }
                            
                            // Campo Senha
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Senha")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button("Recuperar senha") {
                                        // Ação de recuperar senha
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color("PrimaryOrange"))
                                }
                                
                                SecureField("Insira a sua senha", text: $password)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Botões
                    VStack(spacing: 20) {
                        // Botão Confirmar
                        Button {
                            signIn()
                        } label: {
                            if authService.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(height: 20)
                            } else {
                                Text("Confirmar")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            allFieldsFilled ? Color("PrimaryOrange") : Color.gray.opacity(0.3)
                        )
                        .cornerRadius(12)
                        .disabled(!allFieldsFilled || authService.isLoading)
                        
                        // Link para cadastro
                        HStack(spacing: 4) {
                            Text("Não tem uma conta?")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Button("Cadastre-se") {
                                dismiss()
                                showSignUp = true
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("PrimaryOrange"))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
            }
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
            .onChange(of: authService.userSession) {
                if authService.userSession != nil {
                    dismiss()
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