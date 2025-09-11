//
//  WeekCalendarSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct WeekCalendarSection: View {
    @Binding var selectedDate: Date
    @Binding var isCalendarExpanded: Bool
    let hasEventsFor: (Date) -> Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Minha Semana")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color("TextPrimary"))
            
            VStack(spacing: 16) {
                CalendarNavigationHeader(
                    selectedDate: $selectedDate,
                    isCalendarExpanded: $isCalendarExpanded
                )
                
                if isCalendarExpanded {
                    MonthCalendarView(
                        selectedDate: $selectedDate,
                        hasEventsFor: hasEventsFor
                    )
                } else {
                    WeekCalendarView(
                        selectedDate: $selectedDate,
                        hasEventsFor: hasEventsFor
                    )
                }
            }
        }
    }
}
