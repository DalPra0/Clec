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
                                showingAddActivity = true
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
                    ForEach(Array(weekDays.enumerated()), id: \.offset) { index, date in
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
    }
    
    private func selectedDayOffset(geometry: GeometryProxy) -> CGFloat {
        guard let selectedIndex = weekDays.firstIndex(where: { Calendar.current.isDate($0, inSameDayAs: selectedDate) }) else {
            return 0
        }
        let dayWidth = geometry.size.width / 7
        return CGFloat(selectedIndex) * dayWidth
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
