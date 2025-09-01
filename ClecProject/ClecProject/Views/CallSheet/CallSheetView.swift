// MARK: - FILENAME: ClecProject/Views/CallSheet/CallSheetView.swift

//
//  CallSheetView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import SwiftUI

struct CallSheetView: View {
    @EnvironmentObject var projectManager: ProjectManager
    let projectIndex: Int
    @Environment(\.dismiss) var dismiss
    
    func goToRental(index: Int){
        
    }
    
    var body: some View {
        VStack{
            //          CustomToolbarView(message: "", title: "Ordem do dia", returnText: project.name, onReturn: {dismiss()}, centerTitle: false)
            CustomReturn(text: "Ordem do dia")
            VStack(spacing: -8){
                ForEach(projectManager.projects[projectIndex].callSheet.indices, id: \.self) { index in
                    let sheet = projectManager.projects[projectIndex].callSheet[index]
                    RentalDisplay(callSheet: sheet, index: index, onSelect: goToRental)
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .font(.subheadline)
            
            CustomNavigationButton(title: "Adicionar Nova Diaria", destination: CreateCallSheetView().environmentObject(projectManager))
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack{
        CallSheetView(projectIndex: 0)
            .environmentObject(ProjectManager())
            .environmentObject(UserManager())
    }
}
