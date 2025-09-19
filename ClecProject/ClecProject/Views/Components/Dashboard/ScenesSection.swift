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
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var showingEditActivity = false
    @State private var selectedActivity: CallSheetLineInfo?
    
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
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // Botão Excluir
                                Button(role: .destructive) {
                                    deleteActivity(activity)
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                                
                                // Botão Editar
                                Button {
                                    editActivity(activity)
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                .tint(Color("PrimaryOrange"))
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditActivity) {
            if let activity = selectedActivity {
                // TODO: Implementar EditActivityView
                Text("Editar Atividade: \(activity.description)")
            }
        }
    }
    
    private func deleteActivity(_ activity: CallSheetLineInfo) {
        // TODO: Implementar lógica de exclusão no ProjectManager
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        print("🗑️ Deletar atividade: \(activity.description)")
    }
    
    private func editActivity(_ activity: CallSheetLineInfo) {
        selectedActivity = activity
        showingEditActivity = true
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        print("✏️ Editar atividade: \(activity.description)")
    }
}
