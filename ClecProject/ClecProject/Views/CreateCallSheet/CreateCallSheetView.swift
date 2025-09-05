//
//  CreateCallSheetView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 01/09/25.
//

import SwiftUI

struct CreateCallSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var date: Date = Date()
    @State private var showDatePicker = false
    @State private var selectedColorIndex: Int = 3
    @State private var isReminderEnabled: Bool = false
    
    let colorEnums: [CallSheetModel.CallSheetColor] = [.green, .yellow, .blue, .purple]
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
                        
                        titleSection
                        
                        detailsSection
                        
                        colorPickerSection
                        
                        reminderSection
                        
                        // Botão Pronto
                        Button(action: {
                            done()
                        }) {
                            Text("Pronto!")
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
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Adicionar Diária")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Crie uma nova ordem do dia\\npara organizar as filmagens")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex: "#8E8E93"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Título da Diária")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            TextField("Ex: Primeira Diária - Centro", text: $title)
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
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detalhes")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(spacing: 0) {
                // Descrição
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descrição")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    
                    TextField("Descreva a diária...", text: $description)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                }
                
                Divider()
                    .background(Color(hex: "#8E8E93").opacity(0.3))
                    .padding(.vertical, 8)
                
                // Endereço
                VStack(alignment: .leading, spacing: 8) {
                    Text("Endereço")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    
                    TextField("Local da filmagem...", text: $address)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                }
                
                Divider()
                    .background(Color(hex: "#8E8E93").opacity(0.3))
                    .padding(.vertical, 8)
                
                // Data e hora
                VStack(alignment: .leading, spacing: 8) {
                    Text("Data e hora")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    
                    Button(action: {
                        withAnimation {
                            showDatePicker.toggle()
                        }
                    }) {
                        HStack {
                            Text(date, style: .date)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#F85601"))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.clear)
                    }
                }
                
                if showDatePicker {
                    DatePicker(
                        "Selecione a data e hora",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding(.top, 16)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#1C1C1E"))
            )
        }
    }
    
    private var colorPickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cor da Diária")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                ForEach(colorEnums.indices, id: \.self) { index in
                    let color = colorEnums[index].swiftUIColor
                    Button(action: {
                        selectedColorIndex = index
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedColorIndex == index ? Color.white : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "#1C1C1E"), lineWidth: 1)
                            )
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Adicionar lembrete")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Toggle("", isOn: $isReminderEnabled)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#F85601")))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#1C1C1E"))
            )
        }
    }
    
    func done() {
        // Using new activity logic instead of old CallSheet logic
        DispatchQueue.main.async {
            projectManager.addActivityToDay(
                date: date,
                title: title.isEmpty ? "Nova Diária" : title,
                description: description.isEmpty ? title : description,
                address: address.isEmpty ? "Local não definido" : address,
                time: date,
                responsible: ""
            )
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

#Preview {
    CreateCallSheetView()
        .environmentObject(ProjectManager())
}
