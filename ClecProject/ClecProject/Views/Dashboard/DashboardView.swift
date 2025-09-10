//
//  DashboardView.swift
//  ClecProject
//
//  Refactored from monolithic 900+ line file
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
    // MARK: - State
    @State private var selectedDate = Date()
    @State private var showingAllCallSheets = false
    @State private var showingFiles = false
    @State private var showingSettings = false
    @State private var showingAddActivity = false
    @State private var showingAddFile = false
    @State private var showingAddOrdemDoDia = false
    @State private var selectedTab: DashboardTab = .geral
    @State private var isCalendarExpanded = false
    @State private var selectedDayForecast: DailyForecast?
    
    // MARK: - Computed Properties
    private var project: ProjectModel? {
        projectManager.activeProject
    }
    
    private var todaysActivities: [CallSheetLineInfo] {
        projectManager.getActivitiesForDay(selectedDate)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color("BackgroundDark")
                .ignoresSafeArea()
            
            if let project = project {
                mainContent(project: project)
                DashboardFAB { handleFABAction() }
            } else {
                emptyProjectState
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear { fetchWeather(for: selectedDate) }
        .onChange(of: selectedDate) { fetchWeather(for: selectedDate) }
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
        .sheet(isPresented: $showingAddFile) {
            if let project = project,
               let projectIndex = projectManager.projects.firstIndex(where: { $0.id == project.id }) {
                AddFileView(projectIndex: projectIndex)
                    .environmentObject(projectManager)
            }
        }
        .sheet(isPresented: $showingAddOrdemDoDia) {
            CreateCallSheetView()
                .environmentObject(projectManager)
        }
    }
    
    // MARK: - Main Content
    @ViewBuilder
    private func mainContent(project: ProjectModel) -> some View {
        VStack(spacing: 0) {
            DashboardHeaderSection(project: project)
            
            DashboardTabsSection(selectedTab: $selectedTab) { tab in
                handleTabSelection(tab)
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    contentForSelectedTab
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
            }
        }
    }
    
    // MARK: - Content Sections
    @ViewBuilder
    private var contentForSelectedTab: some View {
        switch selectedTab {
        case .geral:
            geralTabContent
        case .arquivos:
            FilesSection(project: project)
        case .ordens:
            OrdersSection(project: project)
        case .configuracoes:
            SettingsSection(project: project)
        }
    }
    
    @ViewBuilder
    private var geralTabContent: some View {
        WeekCalendarSection(
            selectedDate: $selectedDate,
            isCalendarExpanded: $isCalendarExpanded,
            hasEventsFor: hasEventsFor
        )
        
        WeatherInfoSection(selectedDayForecast: selectedDayForecast)
        
        ScenesSection(
            todaysActivities: todaysActivities,
            selectedDate: selectedDate
        )
    }
    
    private var emptyProjectState: some View {
        VStack {
            Text("Nenhum projeto ativo")
                .font(.title2)
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Actions
    private func handleFABAction() {
        switch selectedTab {
        case .geral:
            showingAddActivity = true
        case .arquivos:
            showingAddFile = true
        case .ordens:
            showingAddOrdemDoDia = true
        case .configuracoes:
            selectedDate = Date()
            showingAddActivity = true
        }
    }
    
    private func handleTabSelection(_ tab: DashboardTab) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        selectedTab = tab
    }
    
    private func fetchWeather(for date: Date) {
        selectedDayForecast = nil
        projectManager.getForecast(for: date) { forecast in
            selectedDayForecast = forecast
        }
    }
    
    private func hasEventsFor(date: Date) -> Bool {
        return projectManager.dayHasActivities(date)
    }
}
