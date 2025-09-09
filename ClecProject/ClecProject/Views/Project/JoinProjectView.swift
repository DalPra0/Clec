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
    
    let onProjectJoined: (ProjectModel) -> Void
    
    @State private var code = ""
    @State private var isValidating = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @FocusState private var isTextFieldFocused: Bool
    
    init(onProjectJoined: @escaping (ProjectModel) -> Void = { _ in }) {
        self.onProjectJoined = onProjectJoined
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // FUNDO ESCURO CONSISTENTE
                Color(hex: "#141414")
                    .ignoresSafeArea(.all)
                
                mainContent
            }
            .background(Color(hex: "#141414"))
            .colorScheme(.dark)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Voltar")
                                .font(.system(size: 16, weight: .regular))
                        }
                        .foregroundColor(Color(hex: "#F85601"))
                    }
                }
            }
        }
        .colorScheme(.dark)
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
    
    private var mainContent: some View {
        VStack(spacing: 40) {
            headerSection
                .padding(.horizontal, 32)
                .padding(.top, 40)
            
            Spacer()
            
            codeInputSection
                .padding(.horizontal, 32)
            
            hiddenTextField
            
            Spacer()
        }
    }
    
    private var hiddenTextField: some View {
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
                    .foregroundColor(Color(hex: "#F85601"))
                    
                    Button("Concluír") {
                        isTextFieldFocused = false
                    }
                    .foregroundColor(Color(hex: "#F85601"))
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
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Insira o Código")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Insira o código que o Assistente\nde Direção mandou")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex: "#8E8E93"))
                .multilineTextAlignment(.center)
        }
    }
    
    private var codeInputSection: some View {
        VStack(spacing: 32) {
            CodeInputView(code: $code)
                .onTapGesture {
                    isTextFieldFocused = true
                }
            
            VStack(spacing: 12) {
                if code.isEmpty {
                    Text("Toque para digitar")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#8E8E93"))
                } else if code.count < 4 {
                    VStack(spacing: 8) {
                        Text("Continue digitando...")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#8E8E93"))
                        
                        Button("Limpar") {
                            code = ""
                            isTextFieldFocused = true
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#F85601"))
                    }
                }
                
                if isValidating {
                    HStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#F85601")))
                            .scaleEffect(0.8)
                        
                        Text("Validando código...")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1C1C1E"))
                    )
                }
            }
        }
    }
    
    private func validateCode() {
        guard code.count == 4 else { return }
        
        isValidating = true
        isTextFieldFocused = false
        
        projectManager.joinProject(withCode: code) { project in
            isValidating = false
            if let project = project {
                joinProject(project)
            } else {
                showError("Código não encontrado. Verifique se o código está correto.")
            }
        }
    }
    
    private func joinProject(_ project: ProjectModel) {
        print("✅ Entrando no projeto: \(project.name)")
        onProjectJoined(project)
        
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
