//
//  SceneCardView.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct SceneCardView: View {
    let activity: CallSheetLineInfo
    let selectedDate: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: selectedDate)
    }
    
    private var timeString: String {
        "06:30"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(activity.description)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                
                Text(formattedDate)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextSecondary"))
                
                Spacer()
                
                Text(timeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color("TimeBadge"))
                    )
            }
            
            HStack(spacing: 8) {
                Circle()
                    .fill(Color("TextSecondary"))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    )
                
                Text("Username")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextSecondary"))
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
    }
}
