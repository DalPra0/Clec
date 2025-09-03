//
//  LoginModalView.swift
//  ClecProject
//
//  Created by alsy ★ on 31/08/25.
//

import SwiftUI

struct LoginModalView: View {
    
    @EnvironmentObject var authService: AuthService
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    
    var allFieldsFilled: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 50) {
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Bem-vinde")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 15) {
                    TextField("E-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    SecureField("Senha", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }
            }
            
            VStack(spacing: 20) {
                if authService.isLoading {
                    ProgressView()
                } else {
                    Button(action: signIn) {
                        Text("Entrar")
                            .padding()
                            .foregroundColor(allFieldsFilled ? .black : .gray)
                            .frame(maxWidth: .infinity)
                            .background(allFieldsFilled ? Color.yellow : Color(uiColor: .systemGray3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(!allFieldsFilled)
                }
            }
        }
        .padding(20)
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
    }
    
    private func signIn() {
        Task {
            await authService.signIn(withEmail: email, password: password)
        }
    }
}


#Preview {
//    LoginModalView(appState: .constant(.login))
    LoginModalView()
        .environmentObject(AuthService())
}
