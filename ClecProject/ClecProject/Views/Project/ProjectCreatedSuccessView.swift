//
//  ProjectCreatedSuccessView.swift
//  ClecProject
//
//  Tela de sucesso após criar projeto - mostra código para compartilhar

import SwiftUI

struct ProjectCreatedSuccessView: View {
    let projectName: String
    let projectCode: String
    let onContinue: () -> Void
    
    @State private var showingCopiedFeedback = false
    
    var body: some View {
        ZStack {
            // Fundo usando sistema de cores
            Color("BackgroundMain")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // ICONE DE SUCESSO
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color("PrimaryOrange").opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .fill(Color("PrimaryOrange"))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(showingCopiedFeedback ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showingCopiedFeedback)
                    
                    // TÍTULO DE SUCESSO
                    VStack(spacing: 8) {
                        Text("Projeto Criado!")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("TextPrimary"))
                        
                        Text("Compartilhe este código com sua equipe:")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color("TextSecondary"))
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
                
                // CARD COM CÓDIGO
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text(projectName)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("TextPrimary"))
                            .multilineTextAlignment(.center)
                        
                        // CÓDIGO DESTAQUE
                        VStack(spacing: 12) {
                            Text("Código do Projeto")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("TextSecondary"))
                            
                            Text(projectCode)
                                .font(.system(size: 48, weight: .heavy, design: .monospaced))
                                .foregroundColor(Color("PrimaryOrange"))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color("CardBackground"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color("PrimaryOrange").opacity(0.3), lineWidth: 2)
                                        )
                                )
                        }
                        
                        // BOTÃO COPIAR
                        Button(action: {
                            copyCodeToClipboard()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: showingCopiedFeedback ? "checkmark.circle.fill" : "doc.on.doc")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text(showingCopiedFeedback ? "Copiado!" : "Copiar Código")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(showingCopiedFeedback ? .green : Color("PrimaryOrange"))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .animation(.easeInOut(duration: 0.2), value: showingCopiedFeedback)
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("CardBackground"))
                            .shadow(color: Color("TextSecondary").opacity(0.1), radius: 10, x: 0, y: 4)
                    )
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // BOTÃO CONTINUAR
                Button(action: {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    onContinue()
                }) {
                    Text("Continuar para Dashboard")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color("PrimaryOrange"))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func copyCodeToClipboard() {
        UIPasteboard.general.string = projectCode
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Visual feedback
        withAnimation(.easeInOut(duration: 0.3)) {
            showingCopiedFeedback = true
        }
        
        // Reset feedback após 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingCopiedFeedback = false
            }
        }
        
        print("📋 Código copiado: \(projectCode)")
    }
}

// MARK: - Preview
struct ProjectCreatedSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectCreatedSuccessView(
            projectName: "Meu Filme Incrível",
            projectCode: "AB12",
            onContinue: {
                print("Continuar pressionado")
            }
        )
    }
}
