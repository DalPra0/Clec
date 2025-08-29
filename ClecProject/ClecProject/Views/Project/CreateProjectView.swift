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
    
    // Form States
    @State private var projectName = ""
    @State private var director = ""
    @State private var description = ""
    @State private var selectedScriptFile: String? = nil // Changed from screenPlay to selectedScriptFile
    @State private var deadline: Date? = nil
    
    // Validation & Loading
    @State private var isFormValid = false
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Form Fields
                formSection
                
                // Generated Code Display
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
        .onChange(of: projectName) { _ in validateForm() }
        .onChange(of: director) { _ in validateForm() }
        .onAppear {
            validateForm()
        }
    }
    
    // MARK: - Header Section
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
    
    // MARK: - Form Section
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
    
    // MARK: - Code Section
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
            
            Text("Compartilhe este código com sua equipe")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Navigation Buttons
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
    
    // MARK: - Helper Functions
    private func validateForm() {
        isFormValid = !projectName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                     !director.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func generateProjectCode() -> String {
        // Generate a 4-digit code based on project name or random
        let code = String(format: "%04d", Int.random(in: 1000...9999))
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
            screenPlay: selectedScriptFile, // Now stores the file name
            deadline: deadline,
            callSheet: []
        )
        
        // Add to project manager
        projectManager.addProject(newProject)
        
        // Simulate short delay for better UX
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
