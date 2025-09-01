//
//  ProjectCard.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct ProjectCard: View {
    
    let project: ProjectModel
    let colors: [Color]
    let onTap: () -> Void
    let index: Int
    let projectManager: ProjectManager
    let userManager: UserManager
    
    static let projectColors: [[Color]] = [
        [Color(.systemBlue), Color(.systemCyan)],
        [Color(.systemOrange), Color(.systemYellow)],
        [Color(.systemPurple), Color(.systemPink)],
        [Color(.systemGreen), Color(.systemMint)],
        [Color(.systemRed), Color(.systemOrange)],
        [Color(.systemIndigo), Color(.systemPurple)],
        [Color(.systemBrown), Color(.systemOrange)],
        [Color(.systemTeal), Color(.systemCyan)]
    ]
    
    init(project: ProjectModel, index: Int = 0, projectManager: ProjectManager, userManager: UserManager, onTap: @escaping () -> Void = {}) {
        self.project = project
        self.onTap = onTap
        self.index = index
        self.projectManager = projectManager
        self.userManager = userManager
        
        let colorIndex = index + 1
        let safeIndex = colorIndex % ProjectCard.projectColors.count
        self.colors = ProjectCard.projectColors[safeIndex]
    }
    
    var body: some View {
        NavigationLink(destination: ProjectView(projectIndex:index).environmentObject(projectManager).environmentObject(userManager)) {
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("Dir: \(project.director)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(12)
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: colors.first?.opacity(0.2) ?? Color.clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
        .environmentObject(ProjectManager())
        .environmentObject(UserManager())
//    let sampleProject = ProjectModel(
//        id: UUID(),
//        code: "AB12",
//        director: "João Silva",
//        name: "Curta Metragem - O Início",
//        photo: nil,
//        screenPlay: "roteiro.pdf",
//        deadline: Date(),
//        callSheet: []
//    )
//    
//    return VStack(spacing: 16) {
//        HStack(spacing: 16) {
//            ProjectCard(project: sampleProject, colorIndex: 0)
//            ProjectCard(project: sampleProject, colorIndex: 1)
//        }
//        
//        HStack(spacing: 16) {
//            ProjectCard(project: sampleProject, colorIndex: 2)
//            AddProjectCard()
//        }
//    }
//    .padding()
//    .background(Color(.systemBackground))
}
