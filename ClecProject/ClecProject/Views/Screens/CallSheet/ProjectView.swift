//
//  ProjectView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct ProjectView: View {
    let project: ProjectModel

    var body: some View {
        VStack{
            
        }
        .navigationTitle(Text(project.name))
    }
}

#Preview {
    NavigationStack {
        ProjectView(project: DeveloperHelper.project)
    }
}
