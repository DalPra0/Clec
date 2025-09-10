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
    @State private var showingAddFile = false
    @State private var showingAddOrdemDoDia = false
    @State private var selectedTab: DashboardTab = .geral
    @State private var isCalendarExpanded = false
    @State private var selectedDayForecast: DailyForecast?

    enum DashboardTab: String, CaseIterable {
        case geral = "Geral"
        case arquivos = "Arquivos"
        case ordens = "Ordens do Dia"
        case configuracoes = "Configurações"
    }
    
    private var project: ProjectModel? {
        projectManager.activeProject
    }
    
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
            Color("BackgroundDark")
                .ignoresSafeArea()
            
            if let project = project {
                VStack(spacing: 0) {
                    headerSection(project: project)
                    
                    tabsSection
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            switch selectedTab {
                            case .geral:
                                weekCalendarSection
                                weatherInfoSection
                                scenesSection
                                
                            case .arquivos:
                                filesSection
                                
                            case .ordens:
                                ordensDoDialSection
                                
                            case .configuracoes:
                                settingsSection
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0.6),
                                            Color.clear
                                        ]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .blur(radius: 8)
                            
                            Button(action: {
                                handleFABAction()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#F85601"))
                                        .frame(width: 56, height: 56)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 34)
                }
            } else {
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
        .onAppear {
            fetchWeather(for: selectedDate)
        }
        .onChange(of: selectedDate) {
            fetchWeather(for: selectedDate)
        }
    }
    
    private func fetchWeather(for date: Date) {
        selectedDayForecast = nil
        projectManager.getForecast(for: date) { forecast in
            selectedDayForecast = forecast
        }
    }
    
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
    
    private func headerSection(project: ProjectModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greeting)
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(Color("TextSecondary"))
                
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
    
    private var tabsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(DashboardTab.allCases, id: \.self) { tab in
                    TabButton(
                        title: tab.rawValue,
                        isSelected: selectedTab == tab
                    ) {
                        handleTabSelection(tab)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    
    private func handleTabSelection(_ tab: DashboardTab) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        selectedTab = tab
    }
    
    private var weekCalendarSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Minha Semana")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                calendarNavigationHeader
                
                if isCalendarExpanded {
                    monthCalendarView
                } else {
                    weekCalendarView
                }
            }
        }
    }
    
    private var weatherInfoSection: some View {
        Group {
            if let forecast = selectedDayForecast {
                HStack(spacing: 16) {
                    Image(systemName: forecast.symbolName)
                        .font(.system(size: 44))
                        .foregroundColor(Color("PrimaryOrange"))
                        .frame(width: 60)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(forecast.condition)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Chance de chuva: \(Int(forecast.precipitationChance * 100))%")
                            .font(.system(size: 14))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color("CardBackground"))
                .cornerRadius(16)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedDayForecast != nil)
    }
    
    private var calendarNavigationHeader: some View {
        HStack {
            Button(action: {
                navigatePrevious()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isCalendarExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentMonthName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("PrimaryOrange"))
                        .rotationEffect(.degrees(isCalendarExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isCalendarExpanded)
                }
            }
            
            Spacer()
            
            Button(action: {
                navigateNext()
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
        }
    }
    
    private var weekCalendarView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CalendarBackground"))
                .frame(height: 60)
            
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color("PrimaryOrange"),
                                Color("PrimaryOrange").opacity(0.9)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.width / 7, height: 50)
                    .shadow(color: Color("PrimaryOrange").opacity(0.4), radius: 8, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: selectedDayOffset(geometry: geometry), y: 5)
                    .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: selectedDate)
            }
            
            HStack(spacing: 0) {
                ForEach(currentWeekDays, id: \.self) { date in
                    CalendarDayContentView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        onTap: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedDate = date
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 60)
    }
    
    private var monthCalendarView: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("TextSecondary"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(currentMonthDays, id: \.self) { date in
                    MonthDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .month),
                        hasEvents: hasEventsFor(date: date)
                    ) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedDate = date
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("CalendarBackground"))
            )
        }
    }
    
    private func selectedDayOffset(geometry: GeometryProxy) -> CGFloat {
        guard let selectedIndex = currentWeekDays.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: selectedDate) }) else {
            return 0
        }
        let dayWidth = geometry.size.width / 7
        return CGFloat(selectedIndex) * dayWidth
    }
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: selectedDate).capitalized
    }
    
    private var currentWeekDays: [Date] {
        let calendar = Calendar.current
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start else {
            return []
        }
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek)
        }
    }
    
    private var currentMonthDays: [Date] {
        let calendar = Calendar.current
        guard let monthStart = calendar.dateInterval(of: .month, for: selectedDate)?.start else { return [] }
        
        let weekday = calendar.component(.weekday, from: monthStart)
        let daysFromSunday = (weekday - 1) % 7
        guard let gridStart = calendar.date(byAdding: .day, value: -daysFromSunday, to: monthStart) else { return [] }
        
        return (0..<42).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: gridStart)
        }
    }
    
    private func navigatePrevious() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isCalendarExpanded {
                selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
            } else {
                selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
            }
        }
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func navigateNext() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isCalendarExpanded {
                selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
            } else {
                selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
            }
        }
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func hasEventsFor(date: Date) -> Bool {
        return projectManager.dayHasActivities(date)
    }
    
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
                .foregroundColor(Color("TextSecondary"))
            
            VStack(spacing: 8) {
                Text("Sem trabalho para hoje")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Adicione uma nova cena ou atividade para começar")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var filesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Arquivos do Projeto")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if let project = project, !project.allFiles.isEmpty {
                VStack(spacing: 12) {
                    ForEach(project.allFiles, id: \.id) { file in
                        HStack(spacing: 12) {
                            Image(systemName: file.fileType.icon)
                                .font(.system(size: 20))
                                .foregroundColor(Color("PrimaryOrange"))
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("CardBackground"))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(file.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text(file.fileName)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("TextSecondary"))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(Color("TextSecondary"))
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("CardBackground"))
                        )
                    }
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "folder")
                        .font(.system(size: 48))
                        .foregroundColor(Color("TextSecondary"))
                    
                    VStack(spacing: 8) {
                        Text("Nenhum arquivo ainda")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Adicione roteiros, storyboards e outros arquivos")
                            .font(.system(size: 16))
                            .foregroundColor(Color("TextSecondary"))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }
    
    private var ordensDoDialSection: some View {
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
                VStack(spacing: 20) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 48))
                        .foregroundColor(Color("TextSecondary"))
                    
                    VStack(spacing: 8) {
                        Text("Nenhuma ordem do dia criada")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Crie ordens do dia para organizar as filmagens")
                            .font(.system(size: 16))
                            .foregroundColor(Color("TextSecondary"))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            }
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Configurações")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 20))
                        .foregroundColor(Color("PrimaryOrange"))
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("CardBackground"))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Perfil do Usuário")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(userManager.userName)
                            .font(.system(size: 14))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("CardBackground"))
                )
                
                HStack(spacing: 12) {
                    Image(systemName: "film")
                        .font(.system(size: 20))
                        .foregroundColor(Color("PrimaryOrange"))
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("CardBackground"))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Detalhes do Projeto")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(project?.name ?? "Sem projeto")
                            .font(.system(size: 14))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("CardBackground"))
                )
                
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .foregroundColor(Color("PrimaryOrange"))
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("CardBackground"))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Compartilhar Projeto")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text("Código: \(project?.code ?? "----")")
                            .font(.system(size: 14))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("CardBackground"))
                )
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}

struct MonthDayView: View {
    let date: Date
    let isSelected: Bool
    let isCurrentMonth: Bool
    let hasEvents: Bool
    let onTap: () -> Void
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text(dayNumber)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(textColor)
                
                if hasEvents {
                    Circle()
                        .fill(Color("PrimaryOrange"))
                        .frame(width: 4, height: 4)
                } else {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: isToday ? 1.5 : 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if !isCurrentMonth {
            return Color("TextSecondary").opacity(0.5)
        } else if isToday {
            return Color("PrimaryOrange")
        } else {
            return .white
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color("PrimaryOrange")
        } else {
            return Color.clear
        }
    }
    
    private var borderColor: Color {
        if isToday && !isSelected {
            return Color("PrimaryOrange")
        } else {
            return Color.clear
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, title == "Geral" ? 24 : 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color("PrimaryOrange") : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color("PrimaryOrange"), lineWidth: 1.5)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalendarDayContentView: View {
    let date: Date
    let isSelected: Bool
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
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color("TextSecondary"))
                    .opacity(isSelected ? 1.0 : 0.7)
                
                Text(dayNumber)
                    .font(.system(size: 16, weight: isSelected ? .heavy : .bold))
                    .foregroundColor(isSelected ? .white : .white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(isSelected ? 1.0 : 0.98)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

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
        "06:30"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(activity.description)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                
                Text(formattedDate)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextSecondary"))
                
                Spacer()
                
                Text(timeString)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color("TimeBadge"))
                    )
            }
            
            HStack(spacing: 8) {
                Circle()
                    .fill(Color("TextSecondary"))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                    )
                
                Text("Username")
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextSecondary"))
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CardBackground"))
        )
    }
}
