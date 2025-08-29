//
//  CreateProjectView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct CreateProjectView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            CustomToolbarView(message: "", title: "Insira as informações do projeto", returnText: "Voltar", onReturn: {dismiss()}, centerTitle: true)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        CreateProjectView()
    }
}
