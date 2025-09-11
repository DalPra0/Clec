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
    
    // Call Sheet States
    @State private var title: String = ""
    @State private var selectedColorIndex: Int = 2 // Default to blue
    
    // First Scene States
    @State private var description: String = ""
    @State private var address: String = ""
    @State private var date: Date
    
    @State private var isReminderEnabled: Bool = false
    
    let colorEnums: [CallSheetModel.CallSheetColor] = [.purple, .yellow, .green, .blue]
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(selectedDate: Date = Date()) {
        self._date = State(initialValue: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundDark").ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            titleField
                            detailsCard
                            colorPickerCard
                            reminderToggle
                            Spacer()
                        }
                        .padding(.top, 16)
                        .padding(.horizontal)
                    }
                    
                    footer
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Ordens do Dia")
                }
                .foregroundColor(Color("TextPrimary"))
            }
            .padding(.horizontal)
            
            Text("Adicionar Diária")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("TextPrimary"))
                .padding(.horizontal)
        }
    }
    
    private var titleField: some View {
        VStack(alignment: .leading) {
            TextField("Adicionar título", text: $title)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(Color("TextPrimary"))
                .padding(.bottom, 8)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("TextSecondary"))
        }
    }
    
    private var detailsCard: some View {
        VStack(spacing: 0) {
            CustomDetailRow(placeholder: "Descrição", text: $description)
            Divider().background(Color("TextSecondary").opacity(0.5))
            CustomDetailRow(placeholder: "Endereço", text: $address)
            Divider().background(Color("TextSecondary").opacity(0.5))
            
            DatePicker("Data e hora", selection: $date)
                .datePickerStyle(CompactDatePickerStyle())
                .foregroundColor(Color("TextSecondary"))
                .tint(Color("PrimaryOrange"))
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
        .background(Color("CardBackground"))
        .cornerRadius(12)
    }
    
    private var colorPickerCard: some View {
        HStack {
            ForEach(colorEnums.indices, id: \.self) { index in
                let colorValue = colorEnums[index]
                Circle()
                    .fill(colorValue.swiftUIColor)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(selectedColorIndex == index ? Color.white : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedColorIndex = index
                    }
            }
            Spacer()
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
    }
    
    private var reminderToggle: some View {
        Toggle(isOn: $isReminderEnabled) {
            Text("Adicionar lembrete")
                .foregroundColor(Color("TextPrimary"))
        }
        .toggleStyle(CheckboxToggleStyle())
    }
    
    private var footer: some View {
        Button(action: done) {
            Text("Pronto")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Capsule()
                        .fill(isFormValid ? Color("PrimaryOrange") : Color.gray.opacity(0.3))
                )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isFormValid)
        .padding()
    }

    func done() {
        projectManager.createCallSheetWithFirstScene(
            callSheetTitle: title,
            date: date,
            color: colorEnums[selectedColorIndex],
            sceneDescription: description,
            sceneAddress: address,
            sceneTime: date
        )
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
}

struct CustomDetailRow: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .foregroundColor(Color("TextPrimary"))
            .padding(.horizontal)
            .padding(.vertical, 16)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(configuration.isOn ? Color("PrimaryOrange") : Color("TextSecondary"))
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    CreateCallSheetView(selectedDate: Date())
        .environmentObject(ProjectManager())
}
