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
    
    var body: some View {
        VStack(spacing: 0) {
            CustomReturn(text: "Adicionar diária")
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    titleSection
                    detailsSection
                    colorPickerSection
                    reminderSection
                }
                .padding(.top, 20)
            }
            
            Spacer()
            
            CustomActionButton(title: "Pronto!", onTap: done)
        }
    }
    
    func done() {
        let selectedEnum = colorEnums[selectedColorIndex]
        
        DispatchQueue.main.async {
            projectManager.addCallSheetToCurrentProject(
                title: title,
                description: description,
                address: address,
                date: date,
                color: selectedEnum
            )
        }
        
        dismiss()
    }
}

private extension CreateCallSheetView {
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Adicionar título", text: $title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.gray)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.horizontal)
    }
    
    var detailsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                TextField("Descrição", text: $description)
                    .padding(.vertical, 12)
                Divider()
                TextField("Endereço", text: $address)
                    .padding(.vertical, 12)
                Divider()
                
                HStack {
                    Text("Data e hora")
                    Spacer()
                    Text(date, style: .date)
                }
                .padding(.vertical, 12)
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }
            }
            .foregroundColor(.gray)
            .font(.system(size: 18))
            .padding(.horizontal, 16)
            
            if showDatePicker {
                DatePicker(
                    "Selecione a data e hora",
                    selection: $date,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal)
    }
    
    var colorPickerSection: some View {
        HStack(spacing: 16) {
            ForEach(colorEnums.indices, id: \.self) { index in
                let color = colorEnums[index].swiftUIColor
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(selectedColorIndex == index ? Color.black.opacity(0.5) : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedColorIndex = index
                    }
            }
        }
        .padding(.horizontal)
    }
    
    var reminderSection: some View {
        Toggle(isOn: $isReminderEnabled) {
            Text("Adicionar lembrete")
                .font(.system(size: 18))
                .foregroundColor(.gray)
        }
        .toggleStyle(CheckboxToggleStyle())
        .padding(.horizontal)
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(configuration.isOn ? .accentColor : .gray)
                configuration.label
            }
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    CreateCallSheetView()
        .environmentObject(ProjectManager())
}
