//
//  FilesSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct FilesSection: View {
    let project: ProjectModel?
    
    var body: some View {
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
                EmptyStateView(
                    icon: "folder",
                    title: "Nenhum arquivo ainda",
                    subtitle: "Adicione roteiros, storyboards e outros arquivos"
                )
            }
        }
    }
}
