//
//  WeekCalendarView.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    let hasEventsFor: (Date) -> Bool
    
    private var currentWeekDays: [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start else {
            return []
        }
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    private func selectedDayOffset(geometry: GeometryProxy) -> CGFloat {
        guard let selectedIndex = currentWeekDays.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: selectedDate) }) else {
            return 0
        }
        let dayWidth = geometry.size.width / 7
        return CGFloat(selectedIndex) * dayWidth
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CalendarBackground"))
                .frame(height: 70)
            
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("PrimaryOrange"),
                                Color("PrimaryOrange").opacity(0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.width / 7, height: 60)
                    .shadow(color: Color("PrimaryOrange").opacity(0.4), radius: 8, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: selectedDayOffset(geometry: geometry), y: 5)
                    .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: selectedDate)
            }
            
            HStack(spacing: 0) {
                ForEach(currentWeekDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        hasEvents: hasEventsFor(date),
                        onTap: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedDate = date
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 70)
    }
}
