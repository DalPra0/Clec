//
//  ProjectSettingsView.swift
//  ClecProject
//
//  Project settings view for owners only
//  Created by Lucas Dal Pra Brascher on 10/09/25.
//

import SwiftUI
import FirebaseFirestore

struct ProjectSettingsView: View {
    let project: ProjectModel
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var projectName: String
    @State private var directorName: String
    @State private var projectDescription: String
    @State private var projectDeadline: Date
    @State private var hasDeadline: Bool
    
    @State private var isFormValid = false
    @State private var isSaving = false
    
    init(project: ProjectModel) {
        self.project = project
        self._projectName = State(initialValue: project.name)
        self._directorName = State(initialValue: project.director)
        self._projectDescription = State(initialValue: project.screenPlay ?? "")
        
        if let deadline = project.deadline {
            self._projectDeadline = State(initialValue: deadline)
            self._hasDeadline = State(initialValue: true)
        } else {
            self._projectDeadline = State(initialValue: Date())
            self._hasDeadline = State(initialValue: false)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    basicInfoSection
                    
                    deadlineSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(Color("BackgroundDark"))
            .navigationBarHidden(true)
        }
        .onAppear {
            validateForm()
        }
        .onChange(of: projectName) { _, _ in validateForm() }
        .onChange(of: directorName) { _, _ in validateForm() }
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
            
            Text("Configurações do Projeto")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: saveChanges) {
                if isSaving {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Salvar")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 80, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color("PrimaryOrange"))
                    .opacity(isFormValid && !isSaving ? 1.0 : 0.6)
            )
            .disabled(!isFormValid || isSaving)
        }
    }
    
    // MARK: - Basic Info Section
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Informações Básicas")
            
            VStack(alignment: .leading, spacing: 16) {
                // Project Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nome do Projeto")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Digite o nome do projeto", text: $projectName)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackground"))
                        )
                }
                
                // Director Name
                VStack(alignment: .leading, spacing: 8) {
                    Text("Diretor")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Nome do diretor", text: $directorName)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackground"))
                        )
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrição do Projeto")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    TextField("Descrição do projeto", text: $projectDescription, axis: .vertical)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackground"))
                        )
                        .lineLimit(3...6)
                }
            }
        }
    }
    
    // MARK: - Deadline Section
    private var deadlineSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Prazo de Entrega")
            
            VStack(alignment: .leading, spacing: 16) {
                // Toggle for deadline
                HStack {
                    Toggle("Definir prazo de entrega", isOn: $hasDeadline)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .toggleStyle(SwitchToggleStyle(tint: Color("PrimaryOrange")))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("CardBackground"))
                )
                
                // Date picker (only if deadline is enabled)
                if hasDeadline {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Data de Entrega")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        DatePicker("Data de entrega", selection: $projectDeadline, displayedComponents: .date)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("CardBackground"))
                            )
                            .labelsHidden()
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
    }
    
    // MARK: - Actions
    private func validateForm() {
        let trimmedName = projectName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDirector = directorName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        isFormValid = !trimmedName.isEmpty && !trimmedDirector.isEmpty
    }
    
    private func saveChanges() {
        guard isFormValid, !isSaving else { return }
        
        isSaving = true
        
        // Update project in Firestore
        guard let projectId = project.id else {
            isSaving = false
            return
        }
        
        let db = Firestore.firestore()
        
        var updateData: [String: Any] = [
            "name": projectName.trimmingCharacters(in: .whitespacesAndNewlines),
            "director": directorName.trimmingCharacters(in: .whitespacesAndNewlines),
            "screenPlay": projectDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
        
        // Handle deadline
        if hasDeadline {
            updateData["deadline"] = projectDeadline
        } else {
            updateData["deadline"] = FieldValue.delete()
        }
        
        db.collection("projects").document(projectId).updateData(updateData) { error in
            DispatchQueue.main.async {
                self.isSaving = false
                
                if let error = error {
                    print("❌ Error updating project: \(error.localizedDescription)")
                    // TODO: Show error alert
                } else {
                    print("✅ Project updated successfully")
                    
                    // Haptic feedback
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                    
                    // Dismiss view
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    ProjectSettingsView(project: ProjectModel(
        code: "AB12",
        director: "Christopher Nolan",
        name: "Interstellar",
        deadline: Date(),
        callSheet: [],
        ownerId: "user123",
        members: ["user123"]
    ))
    .background(Color("BackgroundDark"))
    .environmentObject(ProjectManager())
}
