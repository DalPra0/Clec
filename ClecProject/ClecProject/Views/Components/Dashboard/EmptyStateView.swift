//
//  EmptyStateView.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(Color("TextSecondary"))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 16))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}
