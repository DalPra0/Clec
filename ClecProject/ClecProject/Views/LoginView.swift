//
//  LoginView.swift
//  ClecProject
//
//  Created by alsy ★ on 28/08/25.
//

// FILENAME: ClecProject/Views/LoginView.swift

import SwiftUI

struct LoginView: View {
    @State private var showLoginModal = false
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 170) {
                VStack(spacing: 30) {
                    Image(systemName: "film.stack.fill") // Placeholder Icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .foregroundColor(.yellow)
                    
                    Text("CLÉQUI!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 20) {
                    Button {
                        showLoginModal = true
                    } label: {
                        Text("Fazer login")
                            .padding()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    
                    Button {
                        showSignUp = true
                    } label: {
                        Text("Criar conta")
                            .padding()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .background(.yellow)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
 //   LoginView(appState: .constant(.login))
    LoginView()
        .environmentObject(AuthService())
}
