//
//  AddSceneView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct AddSceneView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.dismiss) var dismiss
    
    let selectedDate: Date
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var sceneTime = Date()
    @State private var responsible: String = ""
    @State private var hasReminder: Bool = false
    @State private var reminderTime: Int = 30 // minutos antes
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    formFields
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Adicionar Cena")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Voltar") {
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Pronto") {
                        addScene()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(isFormValid ? .blue : .secondary)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            // Título
            VStack(alignment: .leading, spacing: 8) {
                Text("Adicionar título")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Ex: Cena 01 - Pastelaria", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
            }
            
            // Descrição
            VStack(alignment: .leading, spacing: 8) {
                Text("Descrição")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Descreva brevemente a cena", text: $description, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .lineLimit(3...6)
            }
            
            // Endereço
            VStack(alignment: .leading, spacing: 8) {
                Text("Endereço")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Ex: Rua Margarida - 2207", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
            }
            
            // Data e hora
            VStack(alignment: .leading, spacing: 8) {
                Text("Data e hora")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                DatePicker("", selection: $sceneTime)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            
            // Responsável
            VStack(alignment: .leading, spacing: 8) {
                Text("Responsável")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Nome do responsável", text: $responsible)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
            }
            
            // Lembrete
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Adicionar lembrete")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $hasReminder)
                        .labelsHidden()
                }
                
                if hasReminder {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Avisar com antecedência")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Picker("Tempo do lembrete", selection: $reminderTime) {
                            Text("15 minutos").tag(15)
                            Text("30 minutos").tag(30)
                            Text("1 hora").tag(60)
                            Text("2 horas").tag(120)
                        }
                        .pickerStyle(.segmented)
                    }
                }
            }
        }
    }
    
    private func addScene() {
        guard isFormValid else { return }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Usar a data selecionada no calendário, mas com o horário escolhido
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: sceneTime)
        
        let finalDate = calendar.date(from: DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute
        )) ?? selectedDate
        
        // Determinar cor baseada no número de diárias existentes
        let existingCallSheets = projectManager.activeProject?.callSheet.count ?? 0
        let colors: [CallSheetModel.CallSheetColor] = [.blue, .green, .yellow, .purple]
        let selectedColor = colors[existingCallSheets % colors.count]
        
        projectManager.addCallSheetToCurrentProject(
            title: trimmedTitle,
            description: trimmedDescription.isEmpty ? trimmedTitle : trimmedDescription,
            address: trimmedAddress,
            date: finalDate,
            color: selectedColor
        )
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

#Preview {
    AddSceneView(selectedDate: Date())
        .environmentObject({
            let manager = ProjectManager()
            let mockProject = ProjectModel(
                id: UUID(),
                code: "TEST",
                director: "João Silva",
                name: "Título do filme",
                photo: nil,
                screenPlay: "roteiro.pdf",
                deadline: Date(),
                additionalFiles: [],
                callSheet: []
            )
            manager.setActiveProject(mockProject)
            return manager
        }())
}
