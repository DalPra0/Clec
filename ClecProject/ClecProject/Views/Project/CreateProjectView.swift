//
//  CreateProjectView.swift
//  ClecProject
//
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
                Color("BackgroundCard")
                    .ignoresSafeArea(.all)
                
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
                        VStack(spacing: 24) {
                            headerSection
                            
                            formSection
                            
                            Button(action: {
                                createProject()
                            }) {
                                HStack {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Text("Pronto")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(
                                            isFormValid ? Color("PrimaryOrange") : Color("TextSecondary").opacity(0.3)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!isFormValid || isLoading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            Spacer(minLength: 40)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
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
        .onChange(of: projectName) {
            validateForm()
        }
        .onChange(of: director) {
            validateForm()
        }
        .onAppear {
            validateForm()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Insira as informações")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("TextPrimary"))
                .multilineTextAlignment(.center)
            
            Text("do seu projeto")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color("TextPrimary"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            CustomTextField(
                title: "Nome do Projeto",
                placeholder: "Ex: Curta Metragem",
                text: $projectName
            )
            
            CustomTextField(
                title: "Diretor",
                placeholder: "Nome do diretor",
                text: $director
            )
            
            CustomTextEditor(
                title: "Descrição",
                placeholder: "Descrição breve do projeto...",
                text: $description
            )
            
            CustomDatePicker(
                title: "Data Final",
                date: $deadline
            )
            
            CustomFilePicker(
                title: "Roteiro",
                selectedFileName: $selectedScriptFile
            )
        }
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
        
        print("🔍 Código gerado: \(generatedCode)")
        
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
        
        print("🔍 Projeto criado com código: \(newProject.code)")
        
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
            }
            self.isLoading = false
        }
    }
}
