//
//  AddProjectCard.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct AddProjectCard: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.secondary)
            
            Text("Novo Projeto")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemGray5), Color(.systemGray4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color(.systemGray4).opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    AddProjectCard()
        .padding()
        .background(Color(.systemBackground))
}
