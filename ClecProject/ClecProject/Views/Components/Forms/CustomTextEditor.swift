//
//  CustomTextEditor.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CustomTextEditor: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @State private var isFocused = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#1C1C1E"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isFocused ? Color(hex: "#F85601") : Color.clear,
                                lineWidth: 1.5
                            )
                    )
                    .frame(minHeight: 120)
                
                TextEditor(text: $text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
            }
            .onTapGesture {
                isFocused = true
            }
        }
    }
}

#Preview {
    @Previewable @State var sampleText = ""
    
    return VStack(spacing: 20) {
        CustomTextEditor(
            title: "Descrição",
            placeholder: "Descrição breve do projeto...",
            text: $sampleText
        )
    }
    .padding()
    .background(Color(hex: "#141414"))
}
