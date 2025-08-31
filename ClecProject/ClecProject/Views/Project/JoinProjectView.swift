//
//  JoinProjectView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct JoinProjectView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var code = ""
    @State private var isValidating = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            headerSection
                .padding(.horizontal, 32)
                .padding(.top, 40)
            
            Spacer()
            
            codeInputSection
                .padding(.horizontal, 32)
            
            TextField("", text: $code)
                .keyboardType(.asciiCapable)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .focused($isTextFieldFocused)
                .opacity(0)
                .frame(height: 0)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Limpar") {
                            code = ""
                        }
                        .foregroundColor(.red)
                        
                        Button("Concluir") {
                            isTextFieldFocused = false
                        }
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                    }
                }
                .onChange(of: code) {
                    if code.count > 4 {
                        code = String(code.prefix(4))
                    }
                    code = code.uppercased()
                    
                    if code.count == 4 {
                        validateCode()
                    }
                }
            
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarItems(
            leading: backButton
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .preferredColorScheme(.light)
        .onTapGesture {
            isTextFieldFocused = true
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .alert("Código Inválido", isPresented: $showingError) {
            Button("OK") {
                code = ""
                isTextFieldFocused = true
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Inserir Código")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Insira o código alfanumérico que o\nassistente de direção mandou")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var codeInputSection: some View {
        VStack(spacing: 32) {
            CodeInputView(code: $code)
                .onTapGesture {
                    isTextFieldFocused = true
                }
            
            VStack(spacing: 8) {
                if code.isEmpty {
                    Text("Toque para digitar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if code.count < 4 {
                    HStack(spacing: 16) {
                        Text("🔢 Continue digitando...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button("Limpar") {
                            code = ""
                            isTextFieldFocused = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
                
                if isValidating {
                    HStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.8)
                        
                        Text("Validando código...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
            }
        }
    }
    
    private var backButton: some View {
        Button("Voltar") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(.primary)
    }
    
    private func validateCode() {
        guard code.count == 4 else { return }
        
        isValidating = true
        
        isTextFieldFocused = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let project = projectManager.getProject(by: code) {
                joinProject(project)
            } else {
                showError("Código não encontrado. Verifique se o código está correto.")
            }
            
            isValidating = false
        }
    }
    
    private func joinProject(_ project: ProjectModel) {
        print("✅ Entrando no projeto: \(project.name)")
        
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
        
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
}

#Preview {
    NavigationView {
        JoinProjectView()
            .environmentObject(ProjectManager())
    }
}
