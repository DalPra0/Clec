//
//  CallSheetView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import SwiftUI

struct CallSheetView: View {
    let project: ProjectModel
    let callsheet: CallSheetModel
    @Environment(\.dismiss) var dismiss
    
    func goToRental(index: Int){
        
    }
    
    var body: some View {
        VStack{
            //            CustomToolbarView(message: "", title: "Ordem do dia", returnText: project.name, onReturn: {dismiss()}, centerTitle: false)
            Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Ordem do dia")
                    Spacer()
                }
                .foregroundStyle(.black)
                .fontWeight(.bold)
                .font(.title2)
                .padding(.horizontal, 16)
                .padding(.vertical, 32)
            }

            
            VStack(spacing: -8){
                    ForEach(project.callSheet.indices, id: \.self) { index in
                        let sheet = project.callSheet[index]
                        RentalDisplay(callSheet: sheet, index: index, onSelect: goToRental)
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .font(.subheadline)
            }
        }
    }

#Preview {
    NavigationStack{
        CallSheetView(project: DeveloperHelper.project, callsheet: DeveloperHelper.project.callSheet[0])
    }
}
