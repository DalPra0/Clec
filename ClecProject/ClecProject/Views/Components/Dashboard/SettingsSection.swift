//
//  SettingsSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct SettingsSection: View {
    let project: ProjectModel?
    let userManager: UserManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Configurações")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                // Perfil do Usuário
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
                
                // Detalhes do Projeto
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
                
                // Compartilhar Projeto
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
}
