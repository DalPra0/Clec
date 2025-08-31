//
//  DashboardHeader.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct DashboardHeader: View {
    let userName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(userName)!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(currentDateString)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [Color(.systemGray4), Color(.systemGray5)]),
                        center: .center,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18))
                )
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM."
        formatter.locale = Locale(identifier: "en_US")
        return "Today, \(formatter.string(from: Date()))"
    }
}

#Preview {
    DashboardHeader(userName: "Mia")
        .background(Color(.systemBackground))
}
