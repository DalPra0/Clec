//
//  CalendarNavigationHeader.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct CalendarNavigationHeader: View {
    @Binding var selectedDate: Date
    @Binding var isCalendarExpanded: Bool
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: selectedDate).capitalized
    }
    
    var body: some View {
        HStack {
            Button(action: {
                navigatePrevious()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isCalendarExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentMonthName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("PrimaryOrange"))
                        .rotationEffect(.degrees(isCalendarExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isCalendarExpanded)
                }
            }
            
            Spacer()
            
            Button(action: {
                navigateNext()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
        }
    }
    
    private func navigatePrevious() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isCalendarExpanded {
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
            } else {
                selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
            }
        }
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func navigateNext() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isCalendarExpanded {
                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
            } else {
                selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
            }
        }
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
}
