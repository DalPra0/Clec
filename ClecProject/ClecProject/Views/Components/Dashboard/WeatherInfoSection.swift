//
//  WeatherInfoSection.swift
//  ClecProject
//
//  Extracted from DashboardView.swift
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct WeatherInfoSection: View {
    let selectedDayForecast: DailyForecast?
    
    var body: some View {
        Group {
            if let forecast = selectedDayForecast {
                HStack(spacing: 16) {
                    Image(systemName: forecast.symbolName)
                        .font(.system(size: 44))
                        .foregroundColor(Color("PrimaryOrange"))
                        .frame(width: 60)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(forecast.condition)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Chance de chuva: \(Int(forecast.precipitationChance * 100))%")
                            .font(.system(size: 14))
                            .foregroundColor(Color("TextSecondary"))
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color("CardBackground"))
                .cornerRadius(16)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedDayForecast != nil)
    }
}
