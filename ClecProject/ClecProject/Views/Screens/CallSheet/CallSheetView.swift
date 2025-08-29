//
//  CallSheetView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import SwiftUI

struct CallSheetView: View {
    let project: ProjectModel
    var body: some View {
        @Environment(\.dismiss) var dismiss
    
        VStack{
            CustomToolbarView(message: "", title: "Ordem do dia", returnText: project.name, onReturn: {dismiss()}, centerTitle: false)
            Spacer()
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack{
        CallSheetView(project: DeveloperHelper.project)
    }
}
