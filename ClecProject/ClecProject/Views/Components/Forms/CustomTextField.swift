//
//  CustomTextField.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.body)
        }
    }
}

#Preview {
    @Previewable @State var sampleText = ""
    
    return CustomTextField(
        title: "Nome do Projeto",
        placeholder: "Digite o nome...",
        text: $sampleText
    )
    .padding()
}
