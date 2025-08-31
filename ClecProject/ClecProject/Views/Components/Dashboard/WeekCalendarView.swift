//
//  WeekCalendarView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct WeekCalendarView: View {
    @State private var currentWeek: [Date] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My week")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(currentWeek, id: \.self) { date in
                        WeekDayCard(
                            dayName: dayName(for: date),
                            dayNumber: dayNumber(for: date),
                            isToday: isToday(date),
                            isSelected: isToday(date)
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .onAppear {
            generateCurrentWeek()
        }
    }
    
    private func generateCurrentWeek() {
        let calendar = Calendar.current
        let today = Date()
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return }
        
        var week: [Date] = []
        var currentDay = weekInterval.start
        
        for _ in 0..<7 {
            week.append(currentDay)
            currentDay = calendar.date(byAdding: .day, value: 1, to: currentDay) ?? currentDay
        }
        
        currentWeek = week
    }
    
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func dayNumber(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
}

struct WeekDayCard: View {
    let dayName: String
    let dayNumber: String
    let isToday: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(dayName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .secondary)
            
            Text(dayNumber)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : .primary)
        }
        .frame(width: 50, height: 70)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: isToday && !isSelected ? 2 : 0)
        )
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color(.systemBlue)
        } else {
            return Color(.systemGray6)
        }
    }
    
    private var borderColor: Color {
        return Color(.systemBlue)
    }
}

#Preview {
    WeekCalendarView()
        .background(Color(.systemBackground))
}
