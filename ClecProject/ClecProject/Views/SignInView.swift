//
//  SignInView.swift
//  ClecProject
//
//  Created by alsy ★ on 31/08/25.
//

import SwiftUI

// FILENAME: ClecProject/Views/SignInView.swift

import SwiftUI

struct SignInView: View {
    
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    
    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Criar Conta")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 15) {
                TextField("E-mail", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                SecureField("Senha (mínimo 6 caracteres)", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                SecureField("Confirmar Senha", text: $confirmPassword)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
            }
            
            if authService.isLoading {
                ProgressView()
            } else {
                Button(action: signUp) {
                    Text("Criar conta")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(isFormValid ? .black : .gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.yellow : Color(uiColor: .systemGray3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(!isFormValid)
            }
            
            Spacer()
        }
        .padding(20)
        .navigationTitle("Cadastro")
        .navigationBarTitleDisplayMode(.inline)
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
        .onChange(of: authService.userSession) {
            if authService.userSession != nil {
                dismiss()
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
//    SignInView(appState: .constant(.login))
SignInView()
}
