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
    var onSelectCallSheet: (Date) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            if let project = project, !project.callSheet.isEmpty {
                VStack(spacing: -8) {
                    ForEach(project.callSheet) { callSheet in
                        Button(action: {
                            onSelectCallSheet(callSheet.day)
                        }) {
                            CallSheetCardView(callSheet: callSheet)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            } else {
                EmptyStateView(
                    icon: "doc.text.magnifyingglass",
                    title: "Nenhuma ordem do dia",
                    subtitle: "Crie a primeira ordem do dia para o seu projeto usando o botão '+'"
                )
            }
        }
    }
}
