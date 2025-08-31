//
//  EditProfileView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newUserName: String = ""
    @State private var isFormValid = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray5)]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.secondary)
                                .font(.system(size: 40))
                        )
                    
                    Text("Editar Perfil")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 40)
                
                // Form
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nome")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Seu nome", text: $newUserName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .onSubmit {
                            saveProfile()
                        }
                        .onChange(of: newUserName) {
                            validateForm()
                        }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: saveButton
            )
            .onAppear {
                newUserName = userManager.userName
                validateForm()
            }
        }
    }
    
    // MARK: - Navigation Buttons
    private var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(.primary)
    }
    
    private var saveButton: some View {
        Button("Salvar") {
            saveProfile()
        }
        .foregroundColor(isFormValid ? .blue : .secondary)
        .fontWeight(.semibold)
        .disabled(!isFormValid)
    }
    
    // MARK: - Helper Functions
    private func validateForm() {
        let trimmedName = newUserName.trimmingCharacters(in: .whitespacesAndNewlines)
        isFormValid = !trimmedName.isEmpty && trimmedName != userManager.userName
    }
    
    private func saveProfile() {
        guard isFormValid else { return }
        
        let trimmedName = newUserName.trimmingCharacters(in: .whitespacesAndNewlines)
        userManager.updateUserName(trimmedName)
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditProfileView()
        .environmentObject(UserManager())
}
