//
//  DashboardView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                DashboardHeader(userName: userManager.userName)
                
                WeekCalendarView()
                
                projectsSection
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .preferredColorScheme(.light)
    }
    
    private var projectsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My projects")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            LazyVGrid(columns: columns, spacing: 16) {
                NavigationLink(destination:
                    CreateProjectView()
                        .environmentObject(projectManager)
                ) {
                    AddProjectCard()
                }
                
                ForEach(Array(projectManager.projects.enumerated()), id: \.element.id) { index, project in
                    ProjectCard(
                        project: project,
                        colorIndex: index + 1
                    ) {
                        print("📱 Projeto '\(project.name)' foi clicado (sem navegação)")
                        
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
                
                ForEach(0..<emptySlots, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 140)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var emptySlots: Int {
        let totalProjects = projectManager.projects.count + 1
        let totalSlots = 6
        
        if totalProjects >= totalSlots {
            return 0
        } else {
            return totalSlots - totalProjects
        }
    }
}

#Preview {
    NavigationView {
        DashboardView()
            .environmentObject(ProjectManager())
            .environmentObject(UserManager())
    }
}
