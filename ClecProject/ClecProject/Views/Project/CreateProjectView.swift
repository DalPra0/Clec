//
//  CreateProjectView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

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
    
    init(onProjectCreated: @escaping (ProjectModel) -> Void = { _ in }) {
        self.onProjectCreated = onProjectCreated
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#141414")
                    .ignoresSafeArea(.all)
                
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
                                        isFormValid ? Color(hex: "#F85601") : Color.gray.opacity(0.3)
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
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("do seu projeto")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
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
        
        var newProject = ProjectModel(
            code: generateProjectCode(),
            director: director.trimmingCharacters(in: .whitespacesAndNewlines),
            name: projectName.trimmingCharacters(in: .whitespacesAndNewlines),
            photo: nil,
            screenPlay: selectedScriptFile,
            deadline: deadline,
            additionalFiles: [],
            callSheet: [],
            ownerId: userId,
            members: [userId]
        )
        
        projectManager.addProject(newProject)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if let createdProject = projectManager.projects.first(where: { $0.code == newProject.code }) {
                self.onProjectCreated(createdProject)
            }
            self.isLoading = false
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
