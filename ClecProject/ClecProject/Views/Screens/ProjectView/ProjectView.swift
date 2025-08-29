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
            VStack{
                HStack{}
            }
            Spacer()
        }
}
}

#Preview {
    NavigationStack {
        ProjectView(project: DeveloperHelper.project)
    }
}
