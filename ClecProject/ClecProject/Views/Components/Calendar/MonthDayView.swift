//
//  MonthDayView.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct MonthDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasEvents: Bool
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(textColor)
                
                if hasEvents {
                    Circle()
                        .fill(Color("PrimaryOrange"))
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isToday ? 1.5 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if !isCurrentMonth {
            return Color("TextSecondary").opacity(0.5)
        } else if isToday {
            return Color("PrimaryOrange")
        } else {
            return .white
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color("PrimaryOrange")
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isToday && !isSelected {
            return Color("PrimaryOrange")
        } else {
            return Color.clear
        }
    }
}
