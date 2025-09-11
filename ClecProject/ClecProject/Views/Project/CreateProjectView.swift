//
//  CreateProjectView.swift
//  ClecProject
//
//  Updated with better contrast and keyboard dismiss
//  ATUALIZADO: Mostra tela de sucesso com código após criar projeto

import SwiftUI
import FirebaseAuth

struct CreateProjectView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    
    let onProjectCreated: (ProjectModel) -> Void
    
    @State private var projectName = ""
    @State private var director = ""
    @State private var description = ""
    @State private var selectedScriptFile: String? = nil
    @State private var deadline: Date? = nil
    
    @State private var isFormValid = false
    @State private var isLoading = false
    
    // NOVO: Estados para tela de sucesso
    @State private var showingSuccessView = false
    @State private var createdProjectCode = ""
    @State private var createdProjectName = ""
    
    init(onProjectCreated: @escaping (ProjectModel) -> Void = { _ in }) {
        self.onProjectCreated = onProjectCreated
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundDark")
                    .ignoresSafeArea(.all)
                    .dismissKeyboardOnTap() // Dismiss keyboard when tapping background
                
                if showingSuccessView {
                    // TELA DE SUCESSO
                    ProjectCreatedSuccessView(
                        projectName: createdProjectName,
                        projectCode: createdProjectCode,
                        onContinue: {
                            showingSuccessView = false
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                } else {
                    // TELA DE FORMULÁRIO ORIGINAL
                    ScrollView {
                        VStack(spacing: 32) {
                            headerSection
                            
                            formSection
                            
                            createButton
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showingSuccessView {
                        Button(action: {
                            hideKeyboard() // Hide keyboard before dismissing
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Voltar")
                                    .font(.system(size: 16, weight: .regular))
                            }
                            .foregroundColor(Color("PrimaryOrange"))
                        }
                    }
                }
            }
        }
        .onChange(of: projectName) { _, _ in
            validateForm()
        }
        .onChange(of: director) { _, _ in
            validateForm()
        }
        .onAppear {
            validateForm()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Criar Projeto")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Preencha as informações básicas\\ndo seu novo projeto")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("TextSecondary"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.top, 20)
    }
    
    private var formSection: some View {
        VStack(spacing: 24) {
            CustomTextField(
                title: "Nome do Projeto",
                placeholder: "Ex: Curta Metragem 'Sonhos'",
                text: $projectName
            )
            
            CustomTextField(
                title: "Diretor",
                placeholder: "Nome completo do diretor",
                text: $director
            )
            
            CustomTextEditor(
                title: "Descrição do Projeto",
                placeholder: "Uma breve descrição sobre o projeto, gênero, duração esperada...",
                text: $description
            )
            
            CustomDatePicker(
                title: "Data Final (Opcional)",
                date: $deadline
            )
            
            CustomFilePicker(
                title: "Roteiro (Opcional)",
                selectedFileName: $selectedScriptFile
            )
        }
    }
    
    private var createButton: some View {
        Button(action: {
            hideKeyboard() // Hide keyboard before creating
            createProject()
        }) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                    
                    Text("Criar Projeto")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isFormValid && !isLoading ? 
                            LinearGradient(
                                colors: [Color("PrimaryOrange"), Color("PrimaryOrange").opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [Color("TextSecondary").opacity(0.3), Color("TextSecondary").opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                    .shadow(
                        color: isFormValid && !isLoading ? Color("PrimaryOrange").opacity(0.4) : Color.clear,
                        radius: isFormValid && !isLoading ? 12 : 0,
                        x: 0,
                        y: 6
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isFormValid || isLoading)
        .scaleEffect(isFormValid && !isLoading ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
        .padding(.top, 8)
    }
    
    private func validateForm() {
        isFormValid = !projectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                      !director.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func generateProjectCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<4).map{ _ in characters.randomElement()! })
    }
    
    private func createProject() {
        guard isFormValid, let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        let generatedCode = generateProjectCode()
        let cleanProjectName = projectName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("🔍 Código gerado: \\(generatedCode)")
        
        let newProject = ProjectModel(
            code: generatedCode,
            director: director.trimmingCharacters(in: .whitespacesAndNewlines),
            name: cleanProjectName,
            photo: nil,
            screenPlay: selectedScriptFile,
            deadline: deadline,
            additionalFiles: [],
            callSheet: [],
            ownerId: userId,
            members: [userId]
        )
        
        print("🔍 Projeto criado com código: \\(newProject.code)")
        
        projectManager.addProject(newProject)
        
        // NOVO: Mostrar tela de sucesso ao invés de fechar
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let createdProject = projectManager.projects.first(where: { $0.code == newProject.code }) {
                self.onProjectCreated(createdProject)
                
                // Preparar dados para tela de sucesso
                self.createdProjectCode = newProject.code
                self.createdProjectName = cleanProjectName
                
                // Mostrar tela de sucesso
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.showingSuccessView = true
                }
                
                // Haptic feedback
                let notificationFeedback = UINotificationFeedbackGenerator()
                notificationFeedback.notificationOccurred(.success)
            }
            self.isLoading = false
        }
    }
}

#Preview {
    CreateProjectView()
        .environmentObject(ProjectManager())
        .environmentObject(UserManager())
}
