//
//  CodeInputView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CodeInputView: View {
    @Binding var code: String
    let maxLength: Int = 4
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(0..<maxLength, id: \.self) { index in
                CodeDigitBox(
                    digit: getDigit(at: index),
                    isFilled: index < code.count,
                    isActive: index == code.count && code.count < maxLength
                )
            }
        }
    }
    
    private func getDigit(at index: Int) -> String {
        if index < code.count {
            let digitIndex = code.index(code.startIndex, offsetBy: index)
            return String(code[digitIndex])
        } else {
            return "•"
        }
    }
}

struct CodeDigitBox: View {
    let digit: String
    let isFilled: Bool
    let isActive: Bool
    
    var body: some View {
        Text(digit)
            .font(.system(size: 28, weight: .bold))
            .foregroundColor(textColor)
            .frame(width: 60, height: 80)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isActive ? 2 : 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isActive)
    }
    
    private var textColor: Color {
        if isFilled {
            return .white
        } else {
            return Color(hex: "#8E8E93")
        }
    }
    
    private var backgroundColor: Color {
        if isActive {
            return Color(hex: "#1C1C1E")
        } else {
            return Color(hex: "#1C1C1E")
        }
    }
    
    private var borderColor: Color {
        if isActive {
            return Color(hex: "#F85601") // LARANJA EM VEZ DE AZUL
        } else {
            return Color(hex: "#8E8E93").opacity(0.3)
        }
    }
}

#Preview {
    @Previewable @State var sampleCode = "AB"
    
    return VStack(spacing: 20) {
        CodeInputView(code: $sampleCode)
        
        Button("Add Digit") {
            if sampleCode.count < 4 {
                sampleCode += "7"
            }
        }
        
        Button("Clear") {
            sampleCode = ""
        }
    }
    .padding()
    .background(Color(hex: "#141414"))
}
