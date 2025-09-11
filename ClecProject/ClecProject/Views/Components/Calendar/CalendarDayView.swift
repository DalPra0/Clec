//
//  CalendarDayView.swift
//  ClecProject
//
//  Extracted from DashboardView.swift - CalendarDayContentView
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvents: Bool
    let onTap: () -> Void
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color("TextSecondary"))
                    .opacity(isSelected ? 1.0 : 0.7)
                
                Text(dayNumber)
                    .font(.system(size: 16, weight: isSelected ? .heavy : .bold))
                    .foregroundColor(isSelected ? .white : Color("TextPrimary"))
                
                Circle()
                    .fill(hasEvents ? Color("PrimaryOrange") : Color.clear)
                    .frame(width: 5, height: 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(isSelected ? 1.0 : 0.98)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
