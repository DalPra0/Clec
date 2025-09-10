//
//  WeatherModel.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 09/09/25.
//

import Foundation
import SwiftUI

struct DailyForecast: Identifiable {
    var id: Date { date }
    let date: Date
    let condition: String
    let symbolName: String
    let precipitationChance: Double
    let cloudCover: Double
    let sunrise: Date?
    let sunset: Date?
}

enum WeatherMatchStatus {
    case unknown
    case goodMatch
    case partialMatch
    case badMatch
    case noData

    var icon: String {
        switch self {
        case .unknown:
            return "questionmark.circle"
        case .goodMatch:
            return "checkmark.circle.fill"
        case .partialMatch:
            return "exclamationmark.triangle.fill"
        case .badMatch:
            return "xmark.circle.fill"
        case .noData:
            return "cloud.sun"
        }
    }

    var color: Color {
        switch self {
        case .unknown:
            return .gray
        case .goodMatch:
            return .green
        case .partialMatch:
            return .orange
        case .badMatch:
            return .red
        case .noData:
            return .blue
        }
    }
}
