//
//  CreateProjectView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CreateProjectView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var projectName = ""
    @State private var director = ""
    @State private var description = ""
    @State private var selectedScriptFile: String? = nil
    @State private var deadline: Date? = nil
    
    @State private var isFormValid = false
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                formSection
                
                codeSection
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarItems(
            leading: backButton,
            trailing: createButton
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .preferredColorScheme(.light)
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
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("do seu projeto")
                .font(.largeTitle)
                .fontWeight(.bold)
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
    
    private var codeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Código")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text(generateProjectCode())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemBlue).opacity(0.1))
            .cornerRadius(8)
            
            Text("Compartilhe este código alfanumérico com sua equipe")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var backButton: some View {
        Button("Voltar") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(.primary)
    }
    
    private var createButton: some View {
        Button("Pronto") {
            createProject()
        }
        .foregroundColor(isFormValid ? .blue : .secondary)
        .disabled(!isFormValid || isLoading)
    }
    
    private func validateForm() {
        isFormValid = !projectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                     !director.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func generateProjectCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var code = ""
        
        for _ in 0..<4 {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            code += String(character)
        }
        
        return code
    }
    
    private func createProject() {
        guard isFormValid else { return }
        
        isLoading = true
        
        let newProject = ProjectModel(
            id: UUID(),
            code: generateProjectCode(),
            director: director.trimmingCharacters(in: .whitespacesAndNewlines),
            name: projectName.trimmingCharacters(in: .whitespacesAndNewlines),
            photo: nil,
            screenPlay: selectedScriptFile,
            deadline: deadline,
            additionalFiles: [], // Iniciar com lista vazia
            callSheet: []
        )
        
        projectManager.addProject(newProject)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    NavigationView {
        CreateProjectView()
            .environmentObject(ProjectManager())
    }
}
