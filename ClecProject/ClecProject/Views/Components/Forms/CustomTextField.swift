//
//  CustomTextField.swift
//  ClecProject
//
//  Updated with better contrast and keyboard dismiss
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @State private var isFocused = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
                .accentColor(Color("PrimaryOrange")) // Cursor color
                .focused($isTextFieldFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("CardBackground"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isTextFieldFocused ? Color("PrimaryOrange") : Color("TextSecondary").opacity(0.3),
                                    lineWidth: isTextFieldFocused ? 2 : 1
                                )
                        )
                        .shadow(
                            color: isTextFieldFocused ? Color("PrimaryOrange").opacity(0.3) : Color.clear,
                            radius: isTextFieldFocused ? 8 : 0,
                            x: 0,
                            y: 0
                        )
                )
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFocused = newValue
                    }
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
        
        CustomTextField(
            title: "Diretor",
            placeholder: "Nome do diretor",
            text: $sampleText
        )
    }
    .padding()
    .background(Color("BackgroundDark"))
}
