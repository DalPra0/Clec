//
//  InitialView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var projectManager: ProjectManager
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer(minLength: 80)
            
            // Logo e título
            VStack(spacing: 16) {
                // Logo
                Text("CLÉQUI!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Título de boas-vindas
                Text("Bem vindo!")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                // Descrição
                Text("Você pode escolher criar um projeto\nou entrar em um com código")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            Spacer(minLength: 60)
            
            // Cards de ação
            VStack(spacing: 16) {
                // Card Criar Projeto - NavigationLink
                NavigationLink(destination: 
                    CreateProjectView()
                        .environmentObject(projectManager)
                ) {
                    InitialActionCard(
                        title: "Criar",
                        subtitle: "Eu sou assistente de direção"
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Card Inserir Código - NavigationLink
                NavigationLink(destination:
                    JoinProjectView()
                        .environmentObject(projectManager)
                ) {
                    InitialActionCard(
                        title: "Você tem código?",
                        subtitle: "Clique"
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 32)
        .navigationBarHidden(true)
        .background(Color.white.ignoresSafeArea())
        .preferredColorScheme(.light)
    }
}

#Preview {
    NavigationView {
        InitialView()
            .environmentObject(ProjectManager())
    }
}
