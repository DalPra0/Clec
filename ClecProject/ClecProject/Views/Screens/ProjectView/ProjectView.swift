//
//  ProjectView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct ProjectView: View {
    let project: ProjectModel
    @Environment(\.dismiss) var dismiss


    var body: some View {
        VStack{
            CustomToolbarView(message: "Boa tarde,", title: project.name, returnText: "Meus Projetos", onReturn: {dismiss()}, centerTitle: false)
            Grid{
                GridRow{
                    ProjectViewButton(icon: "archivebox.fill", title: "Arquivos", onClick: {})
                        .gridCellColumns(2)
                    ProjectViewButton(icon: "person.2.fill", title: "Membros", onClick: {})
                        .gridCellColumns(2)
                }
                ProjectViewButton(icon: "", title: "Ordem do dia", onClick: {})
            }
            .padding(.vertical, 68)
            .padding(.horizontal, 24)
            Spacer()
        }
        
}
}

#Preview {
    NavigationStack {
        ProjectView(project: DeveloperHelper.project)
    }
}
