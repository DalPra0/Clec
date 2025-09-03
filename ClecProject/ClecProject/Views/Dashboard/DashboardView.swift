//
//  DashboardView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @State private var selectedDate = Date()
    @State private var showingAllCallSheets = false
    @State private var showingFiles = false
    @State private var showingSettings = false
    @State private var showingAddScene = false
    
    private var project: ProjectModel? {
        projectManager.activeProject
    }
    
    private var todaysCallSheets: [CallSheetModel] {
        guard let project = project else { return [] }
        let calendar = Calendar.current
        return project.callSheet.filter { callSheet in
            calendar.isDate(callSheet.day, inSameDayAs: selectedDate)
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Bom dia"
        case 12..<18: return "Boa tarde"
        default: return "Boa noite"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                if let project = project {
                    VStack(spacing: 0) {
                        header(project: project)
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                weekCalendar
                                
                                scenesSection
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                        
                        Spacer()
                    }
                    
                    // FAB
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showingAddScene = true
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
                } else {
                    // Fallback se não há projeto ativo
                    VStack {
                        Text("Nenhum projeto ativo")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAllCallSheets) {
            AllCallSheetsView()
                .environmentObject(projectManager)
        }
        .sheet(isPresented: $showingFiles) {
            if let project = project,
               let projectIndex = projectManager.projects.firstIndex(where: { $0.id == project.id }) {
                FilesView(projectIndex: projectIndex)
                    .environmentObject(projectManager)
            }
        }
        .sheet(isPresented: $showingAddScene) {
            AddSceneView(selectedDate: selectedDate)
                .environmentObject(projectManager)
        }
    }
    
    private func header(project: ProjectModel) -> some View {
        VStack(spacing: 0) {
            // Top header with buttons
            HStack {
                Spacer()
                
                HStack(spacing: 20) {
                    Button("Todas as diárias") {
                        showingAllCallSheets = true
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    
                    Button("Arquivos") {
                        showingFiles = true
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                    
                    Button("Configurações") {
                        showingSettings = true
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Greeting and project title
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(greeting),")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(project.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                
                Text("My week")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(Color(.systemBackground))
    }
    
    private var weekCalendar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(weekDays, id: \.self) { date in
                    CalendarDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        hasEvents: hasEventsFor(date: date)
                    ) {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var weekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    private func hasEventsFor(date: Date) -> Bool {
        guard let project = project else { return false }
        let calendar = Calendar.current
        return project.callSheet.contains { callSheet in
            calendar.isDate(callSheet.day, inSameDayAs: date)
        }
    }
    
    private var scenesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if todaysCallSheets.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary.opacity(0.6))
                    
                    VStack(spacing: 8) {
                        Text("Sem trabalho para hoje")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Adicione uma nova diária ou cena para começar")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                // Scene cards
                VStack(spacing: 12) {
                    ForEach(todaysCallSheets) { callSheet in
                        CallSheetCardView(callSheet: callSheet)
                    }
                }
            }
        }
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvents: Bool
    let onTap: () -> Void
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(dayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .secondary)
                
                Text(dayNumber)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 60, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.green : (hasEvents ? Color.blue.opacity(0.1) : Color.clear))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(hasEvents && !isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CallSheetCardView: View {
    let callSheet: CallSheetModel
    
    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: callSheet.day)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(callSheet.sheetName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    if let firstScene = callSheet.sceneTable.first {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(formatDate(callSheet.day))
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        HStack(spacing: 8) {
                            Image(systemName: "location")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(firstScene.location.address)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                
                Spacer()
                
                Text(timeRange)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(callSheet.callSheetColor.swiftUIColor)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    DashboardView()
        .environmentObject({
            let manager = ProjectManager()
            // Add mock active project for preview
            let mockProject = ProjectModel(
                id: UUID(),
                code: "TEST",
                director: "João Silva",
                name: "Título do filme",
                photo: nil,
                screenPlay: "roteiro.pdf",
                deadline: Date(),
                additionalFiles: [],
                callSheet: []
            )
            manager.setActiveProject(mockProject)
            return manager
        }())
}
