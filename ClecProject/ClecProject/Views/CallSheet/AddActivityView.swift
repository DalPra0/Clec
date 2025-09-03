//
//  AddActivityView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

enum ActivityType {
    case scene(String)  // Cena customizada
    case schedule(CallSheetModel.ScheduleActivity)  // Atividade padrão
}

struct AddActivityView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.dismiss) var dismiss
    
    let selectedDate: Date
    
    @State private var selectedActivityType: ActivityTypeOption = .scene
    @State private var customSceneTitle: String = ""
    @State private var selectedScheduleActivity: CallSheetModel.ScheduleActivity = .Beginning
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var activityTime = Date()
    @State private var responsible: String = ""
    @State private var hasReminder: Bool = false
    @State private var reminderTime: Int = 30
    
    enum ActivityTypeOption: String, CaseIterable {
        case scene = "Nova Cena"
        case schedule = "Atividade Padrão"
        
        var icon: String {
            switch self {
            case .scene: return "video.fill"
            case .schedule: return "clock.fill"
            }
        }
    }
    
    private var isFormValid: Bool {
        switch selectedActivityType {
        case .scene:
            return !customSceneTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .schedule:
            return !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    private var activityTitle: String {
        switch selectedActivityType {
        case .scene:
            return customSceneTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        case .schedule:
            return selectedScheduleActivity.rawValue
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    activityTypeSection
                    
                    if selectedActivityType == .scene {
                        sceneFields
                    } else {
                        scheduleActivityPicker
                    }
                    
                    commonFields
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Adicionar no dia \(formatSelectedDate())")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Adicionar") {
                        addActivity()
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(isFormValid ? .blue : .secondary)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var activityTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tipo de Atividade")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                ForEach(ActivityTypeOption.allCases, id: \.self) { option in
                    ActivityTypeCard(
                        option: option,
                        isSelected: selectedActivityType == option
                    ) {
                        selectedActivityType = option
                    }
                }
            }
        }
    }
    
    private var sceneFields: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Nome da Cena")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Ex: Cena 01 - Pastelaria", text: $customSceneTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
            }
        }
    }
    
    private var scheduleActivityPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Atividade")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Picker("Atividade", selection: $selectedScheduleActivity) {
                ForEach(getAllScheduleActivities(), id: \.self) { activity in
                    HStack {
                        Text(activity.icon)
                        Text(activity.rawValue)
                    }
                    .tag(activity)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var commonFields: some View {
        VStack(spacing: 20) {
            // Descrição
            VStack(alignment: .leading, spacing: 8) {
                Text("Descrição (opcional)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Detalhes adicionais...", text: $description, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
                    .lineLimit(3...6)
            }
            
            // Endereço
            VStack(alignment: .leading, spacing: 8) {
                Text("Local")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Ex: Rua Margarida - 2207", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
            }
            
            // Horário
            VStack(alignment: .leading, spacing: 8) {
                Text("Horário")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                DatePicker("", selection: $activityTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            
            // Responsável
            VStack(alignment: .leading, spacing: 8) {
                Text("Responsável (opcional)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Nome do responsável", text: $responsible)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 16))
            }
            
            // Lembrete
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Lembrete")
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
    
    // MARK: - Helper Functions
    
    private func formatSelectedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: selectedDate)
    }
    
    private func getAllScheduleActivities() -> [CallSheetModel.ScheduleActivity] {
        return [.Beginning, .StartFilming, .Lunch, .EndFilming, .EndOfRental]
    }
    
    private func addActivity() {
        guard isFormValid else { return }
        
        let trimmedAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Combinar data selecionada com horário escolhido
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: activityTime)
        
        let finalDateTime = calendar.date(from: DateComponents(
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: timeComponents.hour,
            minute: timeComponents.minute
        )) ?? selectedDate
        
        // Adicionar atividade ao dia (o ProjectManager vai gerenciar diárias automaticamente)
        projectManager.addActivityToDay(
            date: selectedDate,
            title: activityTitle,
            description: trimmedDescription.isEmpty ? activityTitle : trimmedDescription,
            address: trimmedAddress,
            time: finalDateTime,
            responsible: responsible.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

// MARK: - Supporting Views

struct ActivityTypeCard: View {
    let option: AddActivityView.ActivityTypeOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: option.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(option.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - ScheduleActivity Extension

extension CallSheetModel.ScheduleActivity {
    var icon: String {
        switch self {
        case .Beginning: return "🏁"
        case .StartFilming: return "🎬"
        case .Lunch: return "🍽️"
        case .EndFilming: return "🎭"
        case .EndOfRental: return "📦"
        }
    }
}

#Preview {
    AddActivityView(selectedDate: Date())
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
