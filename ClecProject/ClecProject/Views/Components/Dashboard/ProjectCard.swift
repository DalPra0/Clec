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
    
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
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
    
    init(project: ProjectModel, index: Int = 0, onTap: @escaping () -> Void = {}) {
        self.project = project
        self.onTap = onTap
        
        let colorIndex = index % ProjectCard.projectColors.count
        self.colors = ProjectCard.projectColors[colorIndex]
    }
    
    var body: some View {
        Button(action: {
            projectManager.setActiveProject(project)
            onTap()
        }) {
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
