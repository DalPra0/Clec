//
//  OrdersSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift - Ordens do Dia section
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct OrdersSection: View {
    let project: ProjectModel?
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ordens do Dia")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if let project = project, !project.callSheet.isEmpty {
                VStack(spacing: 16) {
                    ForEach(Array(project.callSheet.enumerated()), id: \.offset) { index, callSheet in
                        let color = callSheet.callSheetColor.swiftUIColor
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Rectangle()
                                    .fill(color)
                                    .frame(width: 4)
                                    .cornerRadius(2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Diária \(index + 1)")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text(formatDate(callSheet.day))
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("TextSecondary"))
                                }
                                
                                Spacer()
                                
                                Text("\(callSheet.sceneTable.count) cenas")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color("TextSecondary"))
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("TextSecondary"))
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackground"))
                        )
                    }
                }
            } else {
                EmptyStateView(
                    icon: "doc.text",
                    title: "Nenhuma ordem do dia criada",
                    subtitle: "Crie ordens do dia para organizar as filmagens"
                )
            }
        }
    }
}
