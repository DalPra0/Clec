//
//  DashboardTabsSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct DashboardTabsSection: View {
    @Binding var selectedTab: DashboardTab
    let onTabSelection: (DashboardTab) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(DashboardTab.allCases, id: \.self) { tab in
                    TabButton(
                        title: tab.rawValue,
                        isSelected: selectedTab == tab
                    ) {
                        onTabSelection(tab)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
}

enum DashboardTab: String, CaseIterable {
    case geral = "Geral"
    case arquivos = "Arquivos"
    case ordens = "Ordens do Dia"
    case configuracoes = "Configurações"
}
