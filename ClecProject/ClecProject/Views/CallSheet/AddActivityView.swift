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
            ZStack {
                // FUNDO ESCURO CONSISTENTE
                Color(hex: "#141414")
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        activityTypeSection
                        
                        if selectedActivityType == .scene {
                            sceneFields
                        } else {
                            scheduleActivityPicker
                        }
                        
                        commonFields
                        
                        // Botão Adicionar
                        Button(action: {
                            addActivity()
                        }) {
                            Text("Adicionar")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
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
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .background(Color(hex: "#141414"))
            .colorScheme(.dark)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
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
    }
    
    // MARK: - Sections
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Adicionar atividade")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Para o dia \(formatSelectedDate())")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex: "#8E8E93"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var activityTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tipo de Atividade")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
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
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                TextField("Ex: Cena 01 - Pastelaria", text: $customSceneTitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1C1C1E"))
                    )
            }
        }
    }
    
    private var scheduleActivityPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Atividade")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Menu {
                ForEach(getAllScheduleActivities(), id: \.self) { activity in
                    Button(action: {
                        selectedScheduleActivity = activity
                    }) {
                        HStack {
                            Text(activity.icon)
                            Text(activity.rawValue)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedScheduleActivity.icon)
                    Text(selectedScheduleActivity.rawValue)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1C1C1E"))
                )
            }
        }
    }
    
    private var commonFields: some View {
        VStack(spacing: 20) {
            // Descrição
            VStack(alignment: .leading, spacing: 8) {
                Text("Descrição (opcional)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                TextField("Detalhes adicionais...", text: $description, axis: .vertical)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1C1C1E"))
                    )
                    .lineLimit(3...6)
            }
            
            // Endereço
            VStack(alignment: .leading, spacing: 8) {
                Text("Local")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                TextField("Ex: Rua Margarida - 2207", text: $address)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1C1C1E"))
                    )
            }
            
            // Horário
            VStack(alignment: .leading, spacing: 8) {
                Text("Horário")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                DatePicker("", selection: $activityTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1C1C1E"))
                    )
            }
            
            // Responsável
            VStack(alignment: .leading, spacing: 8) {
                Text("Responsável (opcional)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                TextField("Nome do responsável", text: $responsible)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "#1C1C1E"))
                    )
            }
            
            // Lembrete
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Lembrete")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Toggle("", isOn: $hasReminder)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F85601")))
                }
                
                if hasReminder {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Avisar com antecedência")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#8E8E93"))
                        
                        Picker("Tempo do lembrete", selection: $reminderTime) {
                            Text("15 minutos").tag(15)
                            Text("30 minutos").tag(30)
                            Text("1 hora").tag(60)
                            Text("2 horas").tag(120)
                        }
                        .pickerStyle(.segmented)
                        .colorScheme(.dark)
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
                    .foregroundColor(isSelected ? .white : Color(hex: "#F85601"))
                
                Text(option.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "#F85601") : Color(hex: "#1C1C1E"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "#F85601") : Color.clear, lineWidth: 2)
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
