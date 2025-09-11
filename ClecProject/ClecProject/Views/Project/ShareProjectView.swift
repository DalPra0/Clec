//
//  ShareProjectView.swift
//  ClecProject
//
//  Share project view with code display and sharing options
//  Created by Lucas Dal Pra Brascher on 10/09/25.
//

import SwiftUI

struct ShareProjectView: View {
    let project: ProjectModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingShareSheet = false
    @State private var hasCopiedCode = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                headerSection
                
                Spacer()
                
                projectInfoSection
                
                codeDisplaySection
                
                actionsSection
                
                Spacer()
                
                instructionsSection
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color("BackgroundDark"))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingShareSheet) {
            ActivityViewController(
                activityItems: [shareText],
                applicationActivities: nil
            )
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
            
            Spacer()
            
            Text("Compartilhar Projeto")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            // Invisible spacer for balance
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    // MARK: - Project Info Section
    private var projectInfoSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 60))
                .foregroundColor(Color("PrimaryOrange"))
            
            VStack(spacing: 8) {
                Text(project.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Dir. \(project.director)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("TextSecondary"))
            }
        }
    }
    
    // MARK: - Code Display Section
    private var codeDisplaySection: some View {
        VStack(spacing: 16) {
            Text("Código do Projeto")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 0) {
                ForEach(Array(project.code.enumerated()), id: \.offset) { index, character in
                    Text(String(character))
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackground"))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("PrimaryOrange"), lineWidth: 2)
                        )
                    
                    if index < project.code.count - 1 {
                        Spacer()
                            .frame(width: 12)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("CardBackground").opacity(0.5))
        )
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        VStack(spacing: 16) {
            // Copy Code Button
            Button(action: copyCode) {
                HStack(spacing: 12) {
                    Image(systemName: hasCopiedCode ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(hasCopiedCode ? "Código Copiado!" : "Copiar Código")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(hasCopiedCode ? Color.green : Color("PrimaryOrange"))
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Share Button
            Button(action: { showingShareSheet = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("Compartilhar Convite")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color("CardBackground"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color("PrimaryOrange"), lineWidth: 2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Instructions Section
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Como usar o código:")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 8) {
                instructionStep(number: "1", text: "Compartilhe o código com sua equipe")
                instructionStep(number: "2", text: "Peça para abrirem o app CLÉQUI!")
                instructionStep(number: "3", text: "Inserir o código na tela inicial")
                instructionStep(number: "4", text: "Pronto! Eles entrarão no projeto")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground").opacity(0.3))
        )
    }
    
    private func instructionStep(number: String, text: String) -> some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Color("PrimaryOrange"))
                )
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(Color("TextSecondary"))
            
            Spacer()
        }
    }
    
    // MARK: - Computed Properties
    private var shareText: String {
        return """
        🎬 Você foi convidado para o projeto "\(project.name)"!
        
        👨‍💼 Diretor: \(project.director)
        🔑 Código: \(project.code)
        
        Para entrar no projeto:
        1. Baixe o app CLÉQUI! na App Store
        2. Use o código \(project.code) na tela inicial
        
        Vamos fazer um filme incrível juntos! 🎥✨
        """
    }
    
    // MARK: - Actions
    private func copyCode() {
        UIPasteboard.general.string = project.code
        
        // Update UI state
        hasCopiedCode = true
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Reset after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            hasCopiedCode = false
        }
    }
}

// MARK: - Activity View Controller
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ShareProjectView(project: ProjectModel(
        code: "AB12",
        director: "Christopher Nolan",
        name: "Interstellar",
        deadline: Date(),
        callSheet: [],
        ownerId: "user123",
        members: ["user123"]
    ))
    .background(Color("BackgroundDark"))
}
