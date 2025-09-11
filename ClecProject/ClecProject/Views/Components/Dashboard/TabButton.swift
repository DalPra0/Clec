//
//  TabButton.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, title == "Geral" ? 24 : 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color("PrimaryOrange") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("PrimaryOrange"), lineWidth: 1.5)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
