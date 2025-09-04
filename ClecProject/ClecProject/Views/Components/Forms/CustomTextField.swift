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
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1C1C1E"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isFocused ? Color(hex: "#F85601") : Color.clear,
                                    lineWidth: 1.5
                                )
                        )
                )
                .onTapGesture {
                    isFocused = true
                }
                .onSubmit {
                    isFocused = false
                }
        }
    }
}

#Preview {
    @Previewable @State var sampleText = ""
    
    return VStack(spacing: 20) {
        CustomTextField(
            title: "Nome do Projeto",
            placeholder: "Ex: Curta Metragem",
            text: $sampleText
        )
    }
    .padding()
    .background(Color(hex: "#141414"))
}
