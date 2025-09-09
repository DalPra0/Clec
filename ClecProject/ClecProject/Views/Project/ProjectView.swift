//
//  ProjectView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct ProjectView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        if let project = projectManager.activeProject,
           let projectIndex = projectManager.projects.firstIndex(where: { $0.id == project.id }) {
            
            VStack{
                CustomToolbarView(message: "Boa tarde,", title: project.name, returnText: "Meus Projetos", onReturn: {
                    projectManager.setActiveProject(nil)
                }, centerTitle: false)
                Grid{
                    GridRow{
                        NavigationLink(destination: FilesView(projectIndex: projectIndex).environmentObject(projectManager)) {
                            ProjectViewButton(icon: "archivebox.fill", title: "Arquivos", onClick: {})
                        }
                            .gridCellColumns(2)
                        ProjectViewButton(icon: "person.2.fill", title: "Membros", onClick: {})
                            .gridCellColumns(2)
                    }
                    NavigationLink(destination: CallSheetView(projectIndex: projectIndex).environmentObject(projectManager)) {
                        ProjectViewButton(icon: nil, title: "Ordem do dia", onClick: {})
                    }
                }
                .padding(.vertical, 68)
                .padding(.horizontal, 24)
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            
        } else {
            // Fallback view if there is no active project for some reason
            Text("Nenhum projeto selecionado.")
                .onAppear {
                    // This should ideally not be reached if the ContentView logic is correct
                    dismiss()
                }
        }
    }
}

#Preview {
    let devManager = ProjectManager()
    let devProject = DeveloperHelper.project
    devManager.projects = [devProject]
    devManager.activeProject = devProject
    
    return NavigationStack {
        ProjectView()
            .environmentObject(devManager)
            .environmentObject(UserManager())
    }
}
