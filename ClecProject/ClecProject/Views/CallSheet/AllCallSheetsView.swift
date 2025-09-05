//
//  AllCallSheetsView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct AllCallSheetsView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddCallSheet = false
    @State private var selectedCallSheet: CallSheetModel?
    
    private var project: ProjectModel? {
        projectManager.activeProject
    }
    
    private var allCallSheets: [CallSheetModel] {
        project?.callSheet ?? []
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    
                    if allCallSheets.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(allCallSheets) { callSheet in
                                    CallSheetRowView(callSheet: callSheet) {
                                        selectedCallSheet = callSheet
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    
                    Spacer()
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddCallSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddCallSheet) {
            AddActivityView(selectedDate: Date())
                .environmentObject(projectManager)
        }
        .sheet(item: $selectedCallSheet) { callSheet in
            CallSheetDetailView(callSheet: callSheet)
                .environmentObject(projectManager)
        }
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Dashboard")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ordem dia")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Nenhuma diária criada")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Adicione uma nova diária para começar a organizar seu cronograma de filmagem.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct CallSheetRowView: View {
    let callSheet: CallSheetModel
    let onTap: () -> Void
    
    private var colorBar: Color {
        callSheet.callSheetColor.swiftUIColor
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE. dd 'de' MMMM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: callSheet.day)
    }
    
    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let startTime = formatter.string(from: callSheet.day)
        
        // Adicionar 2 horas como exemplo (em um app real, seria calculado)
        let endTime = formatter.string(from: callSheet.day.addingTimeInterval(2 * 3600))
        
        return "\(startTime) - \(endTime) pm"
    }
    
    private var locationAddress: String {
        if let firstScene = callSheet.sceneTable.first {
            return firstScene.location.address
        }
        return "Local não definido"
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Color bar
                Rectangle()
                    .fill(colorBar)
                    .frame(width: 4)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(callSheet.sheetName)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                            
                            Text("\(formattedDate) . \(timeRange)")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "location")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                Text(locationAddress)
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "bell")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                
                                Text("30 minutos antes")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Placeholder for CallSheetDetailView - will be implemented next
struct CallSheetDetailView: View {
    let callSheet: CallSheetModel
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Detalhes da Diária")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(callSheet.sheetName)
                        .font(.headline)
                    
                    ForEach(callSheet.sceneTable) { scene in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Cena \(scene.scene)")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text(scene.description)
                                .font(.body)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    AllCallSheetsView()
        .environmentObject({
            let manager = ProjectManager()
            let mockProject = ProjectModel(
                id: UUID(),
                code: "TEST",
                director: "João Silva", 
                name: "Título do filme",
                photo: nil,
                screenPlay: "roteiro.pdf",
                deadline: Date(),
                additionalFiles: [],
                callSheet: [
                    CallSheetModel(
                        id: UUID(),
                        sheetName: "Diária 01",
                        day: Date(),
                        schedule: [],
                        callSheetColor: .blue,
                        sceneTable: [
                            CallSheetLineInfo(
                                scene: 1,
                                shots: [1],
                                environmentCondition: EnvironmentConditions(environment: "INT.", dayCycle: "DIA", weather: "Ensolarado"),
                                location: SceneLocation(name: "Pastelaria", address: "Rua Margarida - 2207", latitude: 0, longitude: 0),
                                description: "Cena 01 - Pastelaria",
                                characters: []
                            )
                        ]
                    )
                ]
            )
            manager.setActiveProject(mockProject)
            return manager
        }())
}
