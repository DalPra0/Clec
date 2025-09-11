//
//  DashboardFAB.swift
//  ClecProject
//
//  Extracted from DashboardView.swift - Floating Action Button
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct DashboardFAB: View {
    let action: () -> Void
    
    var body: some View {
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
                    
                    Button(action: action) {
                        ZStack {
                            Circle()
                                .fill(Color("PrimaryOrange"))
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
    }
}
