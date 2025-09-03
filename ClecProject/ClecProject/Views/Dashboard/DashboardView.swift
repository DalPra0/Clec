//
//  DashboardView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    @State private var selectedDate = Date()
    @State private var showingAllCallSheets = false
    @State private var showingFiles = false
    @State private var showingSettings = false
    @State private var showingAddActivity = false
    @State private var selectedTab: DashboardTab = .geral
    
    enum DashboardTab: String, CaseIterable {
        case geral = "Geral"
        case arquivos = "Arquivos"
        case ordens = "Ordens do Dia"
        case configuracoes = "Configurações"
    }
    
    private var project: ProjectModel? {
        projectManager.activeProject
    }
    
    // NEW LOGIC: Get all activities for selected day
    private var todaysActivities: [CallSheetLineInfo] {
        projectManager.getActivitiesForDay(selectedDate)
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Bom dia,"
        case 12..<18: return "Boa tarde,"
        default: return "Boa noite,"
        }
    }
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black
                .ignoresSafeArea()
            
            if let project = project {
                VStack(spacing: 0) {
                    headerSection(project: project)
                    
                    tabsSection
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            weekCalendarSection
                            
                            scenesSection
                            
                            // Bottom padding for FAB
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                    }
                }
                
                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddActivity = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(Color(hex: "#FF5722"))
                                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 34) // Safe area bottom
                    }
                }
            } else {
                // Fallback se não há projeto ativo
                VStack {
                    Text("Nenhum projeto ativo")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
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
        .sheet(isPresented: $showingAddActivity) {
            AddActivityView(selectedDate: selectedDate)
                .environmentObject(projectManager)
        }
    }
    
    // MARK: - Header Section
    private func headerSection(project: ProjectModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Text(project.name)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Tabs Section
    private var tabsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(DashboardTab.allCases, id: \.self) { tab in
                    TabButton(
                        title: tab.rawValue,
                        isSelected: selectedTab == tab
                    ) {
                        selectedTab = tab
                        handleTabSelection(tab)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    
    private func handleTabSelection(_ tab: DashboardTab) {
        switch tab {
        case .geral:
            break // Already on main view
        case .arquivos:
            showingFiles = true
        case .ordens:
            showingAllCallSheets = true
        case .configuracoes:
            showingSettings = true
        }
        
        // Reset to geral after action
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            selectedTab = .geral
        }
    }
    
    // MARK: - Week Calendar Section
    private var weekCalendarSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Minha Semana")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
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
        return projectManager.dayHasActivities(date)
    }
    
    // MARK: - Scenes Section
    private var scenesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Cenas desse dia")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if todaysActivities.isEmpty {
                emptyState
            } else {
                VStack(spacing: 16) {
                    ForEach(todaysActivities) { activity in
                        SceneCardView(activity: activity, selectedDate: selectedDate)
                    }
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "film")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "#9CA3AF"))
            
            VStack(spacing: 8) {
                Text("Sem trabalho para hoje")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Adicione uma nova cena ou atividade para começar")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

// MARK: - Tab Button Component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: "#FF5722") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "#FF5722"), lineWidth: 1.5)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Calendar Day Component
struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasEvents: Bool
    let onTap: () -> Void
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(hex: "#9CA3AF"))
                
                Text(dayNumber)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isSelected ? .white : .white)
            }
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "#FF5722") : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Scene Card Component
struct SceneCardView: View {
    let activity: CallSheetLineInfo
    let selectedDate: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: selectedDate)
    }
    
    private var timeString: String {
        "06:30" // Mock time for now
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(activity.description)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Text(formattedDate)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Spacer()
                
                Text(timeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(hex: "#E879F9"))
                    )
            }
            
            HStack(spacing: 8) {
                // Mock avatar
                Circle()
                    .fill(Color(hex: "#9CA3AF"))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    )
                
                Text("Username")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#1F1F1F"))
        )
    }
}

#Preview {
    DashboardView()
        .environmentObject({
            let manager = ProjectManager()
            let userManager = UserManager()
            userManager.updateUserName("Lucas")
            
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
        .environmentObject({
            let userManager = UserManager()
            userManager.updateUserName("Lucas")
            return userManager
        }())
}
