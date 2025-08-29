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
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Button(action: {
                    showingPicker = true
                }) {
                    HStack {
                        Text(dateText)
                            .foregroundColor(date == nil ? .secondary : .primary)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                
                if date != nil {
                    Button(action: {
                        date = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingPicker) {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Button("Cancelar") {
                        showingPicker = false
                    }
                    
                    Spacer()
                    
                    Text("Data Final")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Confirmar") {
                        date = tempDate
                        showingPicker = false
                    }
                }
                .padding()
                
                // DatePicker
                DatePicker(
                    "Selecione a data",
                    selection: $tempDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Spacer()
            }
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
    @State var sampleDate: Date? = nil
    
    return CustomDatePicker(
        title: "Data Final",
        date: $sampleDate
    )
    .padding()
}
