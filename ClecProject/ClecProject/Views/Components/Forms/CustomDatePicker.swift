//
//  CustomDatePicker.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct CustomDatePicker: View {
    let title: String
    @Binding var date: Date?
    @State private var showingPicker = false
    @State private var tempDate = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Button(action: {
                tempDate = date ?? Date()
                showingPicker = true
            }) {
                HStack {
                    Text(dateText)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(date == nil ? Color(hex: "#8E8E93") : .white)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#F85601"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1C1C1E"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.clear, lineWidth: 1.5)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .sheet(isPresented: $showingPicker) {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancelar") {
                        showingPicker = false
                    }
                    .foregroundColor(Color(hex: "#F85601"))
                    
                    Spacer()
                    
                    Text("Data Final")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button("Confirmar") {
                        date = tempDate
                        showingPicker = false
                    }
                    .foregroundColor(Color(hex: "#F85601"))
                    .fontWeight(.semibold)
                }
                .padding()
                .background(Color(hex: "#1C1C1E"))
                
                // Date Picker
                DatePicker(
                    "Selecione a data",
                    selection: $tempDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                .background(Color(hex: "#141414"))
                .colorScheme(.dark)
                
                Spacer()
            }
            .background(Color(hex: "#141414"))
            .presentationDetents([.medium])
        }
        .onAppear {
            tempDate = date ?? Date()
        }
    }
    
    private var dateText: String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "pt_BR")
            return formatter.string(from: date)
        } else {
            return "Selecione uma data"
        }
    }
}

#Preview {
    @Previewable @State var sampleDate: Date? = nil
    
    return VStack(spacing: 20) {
        CustomDatePicker(
            title: "Data Final",
            date: $sampleDate
        )
    }
    .padding()
    .background(Color(hex: "#141414"))
}
