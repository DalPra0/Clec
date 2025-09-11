//
//  DashboardHeaderSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct DashboardHeaderSection: View {
    let project: ProjectModel
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Bom dia,"
        case 12..<18: return "Boa tarde,"
        default: return "Boa noite,"
        }
    }
    
    var body: some View {
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
}
