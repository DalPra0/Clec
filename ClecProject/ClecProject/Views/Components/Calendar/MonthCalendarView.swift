//
//  MonthCalendarView.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    let hasEventsFor: (Date) -> Bool
    
    private var currentMonthDays: [Date] {
        let calendar = Calendar.current
        guard let monthStart = calendar.dateInterval(of: .month, for: selectedDate)?.start else { return [] }
        
        let weekday = calendar.component(.weekday, from: monthStart)
        let daysFromSunday = (weekday - 1) % 7
        guard let gridStart = calendar.date(byAdding: .day, value: -daysFromSunday, to: monthStart) else { return [] }
        
        return (0..<42).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: gridStart)
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("TextSecondary"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(currentMonthDays, id: \.self) { date in
                    MonthDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        hasEvents: hasEventsFor(date)
                    ) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("CalendarBackground"))
            )
        }
    }
}
