//
//  CustomTextEditor.swift
//  ClecProject
//
//  Updated with better contrast and keyboard dismiss
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CustomTextEditor: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    @State private var isFocused = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("CardBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isTextEditorFocused ? Color("PrimaryOrange") : Color("TextSecondary").opacity(0.3),
                                lineWidth: isTextEditorFocused ? 2 : 1
                            )
                    )
                    .shadow(
                        color: isTextEditorFocused ? Color("PrimaryOrange").opacity(0.3) : Color.clear,
                        radius: isTextEditorFocused ? 8 : 0,
                        x: 0,
                        y: 0
                    )
                    .frame(minHeight: 120)
                
                TextEditor(text: $text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .accentColor(Color("PrimaryOrange")) // Cursor color
                    .focused($isTextEditorFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color("TextSecondary"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
            .onChange(of: isTextEditorFocused) { oldValue, newValue in
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
        CustomTextEditor(
            title: "Descrição",
            placeholder: "Descrição breve do projeto...",
            text: $sampleText
        )
    }
    .padding()
    .background(Color("BackgroundDark"))
}
