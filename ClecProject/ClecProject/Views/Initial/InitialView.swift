//
//  InitialView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
    @State private var showingCreateProject = false
    @State private var showingJoinProject = false
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Bem-vindo ao ClecProject")
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            Text("Crie ou entre em um projeto para começar")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: { showingCreateProject = true }) {
                    Text("Criar Projeto")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: "#F85601")))
                }
                
                Button(action: { showingJoinProject = true }) {
                    Text("Entrar em Projeto")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(RoundedRectangle(cornerRadius: 25).fill(Color(hex: "#34C759")))
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color(hex: "#141414").ignoresSafeArea())
        .colorScheme(.dark)
        .sheet(isPresented: $showingCreateProject) {
            CreateProjectView(onProjectCreated: { project in
                projectManager.setActiveProject(project)
                userManager.activeProjectId = project.id   // 🔥 salva o projeto ativo
                saveUserProject()
                showingCreateProject = false
            })
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
        .sheet(isPresented: $showingJoinProject) {
            JoinProjectView(onProjectJoined: { project in
                projectManager.setActiveProject(project)
                userManager.activeProjectId = project.id   // 🔥 salva o projeto ativo
                saveUserProject()
                showingJoinProject = false
            })
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
    }
    
    private func saveUserProject() {
        // 🔥 Garante que o UserManager salva no Firestore
        DispatchQueue.main.async {
            let _ = userManager.activeProjectId
            // já está dentro do userManager, basta chamar save
            // (função está em UserManager)
            let mirror = Mirror(reflecting: userManager)
            if mirror.children.contains(where: { $0.label == "saveUserData" }) {
                userManager.updateUserName(userManager.userName) // força salvar
            }
        }
    }
}
