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
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var showingEditOrder = false
    @State private var selectedCallSheet: CallSheetModel?
    
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            // Botão Excluir
                            Button(role: .destructive) {
                                deleteCallSheet(callSheet)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            
                            // Botão Editar
                            Button {
                                editCallSheet(callSheet)
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            .tint(Color("PrimaryOrange"))
                        }
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
        .sheet(isPresented: $showingEditOrder) {
            if let callSheet = selectedCallSheet {
                // TODO: Implementar EditCallSheetView
                Text("Editar Ordem do Dia: \(callSheet.sheetName)")
            }
        }
    }
    
    private func deleteCallSheet(_ callSheet: CallSheetModel) {
        // TODO: Implementar lógica de exclusão de CallSheet no ProjectManager
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        print("🗑️ Ordem do dia deletada: \(callSheet.sheetName)")
    }
    
    private func editCallSheet(_ callSheet: CallSheetModel) {
        selectedCallSheet = callSheet
        showingEditOrder = true
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        print("✏️ Editar ordem do dia: \(callSheet.sheetName)")
    }
}
