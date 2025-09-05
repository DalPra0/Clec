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
    @State private var currentWeekOffset = 0 // Para navegação de semanas
    @State private var currentMonthOffset = 0 // Para navegação de meses
    
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
            // Dark background using asset color
            Color("BackgroundDark")
                .ignoresSafeArea()
            
            if let project = project {
                VStack(spacing: 0) {
                    headerSection(project: project)
                    
                    tabsSection
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // TROCA CONTEÚDO BASEADO NO TAB SELECIONADO
                            switch selectedTab {
                            case .geral:
                                weekCalendarSection
                                scenesSection
                                
                            case .arquivos:
                                filesSection
                                
                            case .ordens:
                                ordensDoDialSection // MESMO CONTEÚDO DA SHEET, MAS NO DASHBOARD
                                
                            case .configuracoes:
                                settingsSection
                            }
                            
                            // Bottom padding for FAB
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 32)
                    }
                }
                
                // FAB - Botão liso laranja + Gradient atrás
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        ZStack {
                            // GRADIENT DE FUNDO - ATRÁS DO BOTÃO
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.black.opacity(0.6),    // Preto embaixo
                                            Color.clear                   // Transparente topo
                                        ]),
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: 80, height: 80) // Maior que o botão para criar o glow
                                .blur(radius: 8) // Blur no gradient de fundo
                            
                            // BOTÃO LISO LARANJA
                            Button(action: {
                                handleFABAction()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#F85601")) // LISO, SEM GRADIENT
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
    
    // MARK: - FAB Action Handler
    private func handleFABAction() {
        switch selectedTab {
        case .geral:
            // Adiciona nova cena/atividade no dia selecionado
            showingAddActivity = true
            
        case .arquivos:
            // Adiciona arquivo
            showingAddFile = true
            
        case .ordens:
            // Adiciona nova ordem do dia
            showingAddOrdemDoDia = true
            
        case .configuracoes:
            // Adiciona nova cena no dia de hoje
            selectedDate = Date() // Seleciona hoje
            showingAddActivity = true
        }
    }
    
    // MARK: - Header Section
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
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Just change the selected tab - TROCA CONTEÚDO NO DASHBOARD
        selectedTab = tab
    }
    
    // MARK: - Week Calendar Section
    private var weekCalendarSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Minha Semana")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                // Header com navegação
                calendarNavigationHeader
                
                // Calendário (semana ou mês)
                if isCalendarExpanded {
                    monthCalendarView
                } else {
                    weekCalendarView
                }
            }
        }
    }
    
    // MARK: - Calendar Navigation Header
    private var calendarNavigationHeader: some View {
        HStack {
            // Seta esquerda
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
            
            // Mês e botão de expandir
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isCalendarExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentMonthName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: isCalendarExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("PrimaryOrange"))
                        .rotationEffect(.degrees(isCalendarExpanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.3), value: isCalendarExpanded)
                }
            }
            
            Spacer()
            
            // Seta direita
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
    
    // MARK: - Week Calendar View
    private var weekCalendarView: some View {
        // Calendar container - continuous rectangle like Figma
        ZStack {
            // Background container
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("CalendarBackground"))
                .frame(height: 60)
            
            // Sliding selection indicator
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
                    .frame(width: geometry.size.width / 7, height: 48)
                    .shadow(color: Color("PrimaryOrange").opacity(0.4), radius: 8, x: 0, y: 2)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .offset(x: selectedDayOffset(geometry: geometry))
                    .animation(.interpolatingSpring(stiffness: 300, damping: 30), value: selectedDate)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            
            // Days content
            HStack(spacing: 0) {
                ForEach(Array(currentWeekDays.enumerated()), id: \.offset) { index, date in
                    CalendarDayContentView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        hasEvents: hasEventsFor(date: date)
                    ) {
                        // Add haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedDate = date
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 60)
    }
    
    // MARK: - Month Calendar View
    private var monthCalendarView: some View {
        VStack(spacing: 12) {
            // Dias da semana (header)
            HStack {
                ForEach(["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color("TextSecondary"))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            
            // Grid do mês
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(currentMonthDays, id: \.self) { date in
                    MonthDayView(
                        date: date,
                        isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: currentDisplayedMonth, toGranularity: .month),
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
    
    // MARK: - Calendar Computed Properties
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: currentDisplayedMonth).capitalized
    }
    
    private var currentDisplayedMonth: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: currentMonthOffset, to: Date()) ?? Date()
    }
    
    private var currentWeekDays: [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        // Calcular a semana base (semana atual + offset)
        let baseWeekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? today
        let targetWeekStart = calendar.date(byAdding: .weekOfYear, value: currentWeekOffset, to: baseWeekStart) ?? baseWeekStart
        
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: targetWeekStart)
        }
    }
    
    private var currentMonthDays: [Date] {
        let calendar = Calendar.current
        let month = currentDisplayedMonth
        
        // Primeiro dia do mês
        guard let monthStart = calendar.dateInterval(of: .month, for: month)?.start else { return [] }
        
        // Primeiro domingo da grade (pode ser do mês anterior)
        let weekday = calendar.component(.weekday, from: monthStart)
        let daysFromSunday = (weekday - 1) % 7
        guard let gridStart = calendar.date(byAdding: .day, value: -daysFromSunday, to: monthStart) else { return [] }
        
        // Gerar 42 dias (6 semanas x 7 dias) para garantir que cubra o mês completo
        return (0..<42).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: gridStart)
        }
    }
    
    // MARK: - Navigation Functions
    
    private func navigatePrevious() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isCalendarExpanded {
                // Modo mês: voltar mês
                currentMonthOffset -= 1
            } else {
                // Modo semana: voltar semana
                currentWeekOffset -= 1
            }
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    private func navigateNext() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if isCalendarExpanded {
                // Modo mês: avançar mês
                currentMonthOffset += 1
            } else {
                // Modo semana: avançar semana
                currentWeekOffset += 1
            }
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
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
    
    // MARK: - Files Section
    private var filesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Arquivos do Projeto")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if let project = project, !project.allFiles.isEmpty {
                VStack(spacing: 12) {
                    ForEach(project.allFiles, id: \.fileName) { file in
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
    
    // MARK: - Ordens do Dia Section (MESMO CONTEÚDO DA SHEET)
    private var ordensDoDialSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ordens do Dia")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            if let project = project, !project.callSheet.isEmpty {
                VStack(spacing: 16) {
                    ForEach(Array(project.callSheet.enumerated()), id: \.offset) { index, callSheet in
                        let color = CallSheetModel.CallSheetColor.allColors()[index % CallSheetModel.CallSheetColor.allColors().count]
                        
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
    
    // MARK: - Settings Section
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

// MARK: - Month Day View Component
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
                
                // Indicador de eventos
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
                .padding(.horizontal, title == "Geral" ? 24 : 20) // Geral is slightly wider
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

// MARK: - Calendar Day Content Component (For sliding animation)
struct CalendarDayContentView: View {
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
            VStack(spacing: 2) {
                Text(dayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color("TextSecondary"))
                    .opacity(isSelected ? 1.0 : 0.7)
                    .scaleEffect(isSelected ? 1.0 : 0.95)
                    .animation(.easeInOut(duration: 0.25).delay(isSelected ? 0.1 : 0), value: isSelected)
                
                Text(dayNumber)
                    .font(.system(size: 16, weight: isSelected ? .heavy : .bold))
                    .foregroundColor(isSelected ? .white : .white)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                    .opacity(isSelected ? 1.0 : 0.8)
                    .animation(.interpolatingSpring(stiffness: 400, damping: 25).delay(isSelected ? 0.05 : 0), value: isSelected)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaleEffect(isSelected ? 1.0 : 0.98)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
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
                // Mock avatar
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
