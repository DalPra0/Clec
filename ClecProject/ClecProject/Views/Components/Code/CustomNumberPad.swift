//
//  CustomNumberPad.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CustomNumberPad: View {
    @Binding var code: String
    let maxLength: Int = 4
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                NumberPadButton(number: "1", action: { addDigit("1") })
                NumberPadButton(number: "2", action: { addDigit("2") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("ABC")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
                NumberPadButton(number: "3", action: { addDigit("3") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("DEF")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
            }
            
            HStack(spacing: 0) {
                NumberPadButton(number: "4", action: { addDigit("4") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("GHI")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
                NumberPadButton(number: "5", action: { addDigit("5") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("JKL")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
                NumberPadButton(number: "6", action: { addDigit("6") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("MNO")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
            }
            
            HStack(spacing: 0) {
                NumberPadButton(number: "7", action: { addDigit("7") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("PQRS")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
                NumberPadButton(number: "8", action: { addDigit("8") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("TUV")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
                NumberPadButton(number: "9", action: { addDigit("9") })
                    .overlay(
                        VStack {
                            Spacer().frame(height: 8)
                            Text("WXYZ")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    )
            }
            
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 75)
                
                NumberPadButton(number: "0", action: { addDigit("0") })
                
                Button(action: removeDigit) {
                    Image(systemName: "delete.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 75)
                        .background(Color(.systemGray6))
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color(.systemBackground))
    }
    
    private func addDigit(_ digit: String) {
        if code.count < maxLength {
            code += digit
            impactFeedback.impactOccurred()
        }
    }
    
    private func removeDigit() {
        if !code.isEmpty {
            code.removeLast()
            impactFeedback.impactOccurred()
        }
    }
}

struct NumberPadButton: View {
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.largeTitle)
                .fontWeight(.regular)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 75)
                .background(Color(.systemGray6))
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var sampleCode = ""
    
    return VStack {
        CodeInputView(code: $sampleCode)
            .padding()
        
        Text("Código: \(sampleCode)")
            .padding()
        
        CustomNumberPad(code: $sampleCode)
    }
}
