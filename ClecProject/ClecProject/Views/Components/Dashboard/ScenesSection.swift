//
//  ScenesSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct ScenesSection: View {
    let todaysActivities: [CallSheetLineInfo]
    let selectedDate: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cenas desse dia")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if todaysActivities.isEmpty {
                EmptyStateView(
                    icon: "film",
                    title: "Sem trabalho para hoje",
                    subtitle: "Adicione uma nova cena ou atividade para começar"
                )
            } else {
                VStack(spacing: 16) {
                    ForEach(todaysActivities) { activity in
                        SceneCardView(activity: activity, selectedDate: selectedDate)
                    }
                }
            }
        }
    }
}
