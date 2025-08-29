//
//  DashboardView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var projectManager: ProjectManager
    
    var body: some View {
        VStack {
            Text("Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Você tem \(projectManager.projects.count) projeto(s)")
                .font(.title2)
                .foregroundColor(.secondary)
            
            // TODO: Implementar design completo do dashboard
            // - Header com perfil e data
            // - Calendário semanal "My week"
            // - Grid de projetos "My projects"
            
            Spacer()
        }
        .padding()
        .navigationTitle("Clec")
        .background(Color.white.ignoresSafeArea())
        .preferredColorScheme(.light)
    }
}

#Preview {
    NavigationView {
        DashboardView()
            .environmentObject(ProjectManager())
    }
}
