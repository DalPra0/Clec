//
//  WeatherServices.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 09/09/25.
//

import Foundation
import WeatherKit
import CoreLocation

enum WeatherError: Error {
    case dataUnavailable
    case forecastNotFoundForDate
}

class WeatherService {
    
    static let shared = WeatherService()
    private let service = WeatherKit.WeatherService.shared
    
    private init() {}

    func fetchForecast(for location: CLLocation) async throws -> [DailyForecast] {
        do {
            let (dailyResult, hourlyResult) = try await service.weather(for: location, including: .daily, .hourly)
            
            let dailyForecasts = dailyResult.forecast.map { dayWeather -> DailyForecast in
                let averageCloudCover = calculateAverageCloudCover(for: dayWeather, in: hourlyResult)
                
                return DailyForecast(
                    date: dayWeather.date,
                    condition: dayWeather.condition.description,
                    symbolName: dayWeather.symbolName,
                    precipitationChance: dayWeather.precipitationChance,
                    cloudCover: averageCloudCover,
                    sunrise: dayWeather.sun.sunrise,
                    sunset: dayWeather.sun.sunset
                )
            }
            return dailyForecasts
            
        } catch {
            throw WeatherError.dataUnavailable
        }
    }
    
    private func calculateAverageCloudCover(for day: DayWeather, in hourlyForecast: Forecast<HourWeather>) -> Double {
        let calendar = Calendar.current
        
        let hoursForDay = hourlyForecast.filter { hourlyWeather in
            return calendar.isDate(hourlyWeather.date, inSameDayAs: day.date)
        }
        
        guard !hoursForDay.isEmpty else { return 0.5 }

        let daylightHours = hoursForDay.filter {
            let hour = calendar.component(.hour, from: $0.date)
            return hour >= 7 && hour <= 19
        }
        
        let relevantHours = daylightHours.isEmpty ? hoursForDay : daylightHours
        
        let totalCloudCover = relevantHours.reduce(0.0) { $0 + $1.cloudCover }
        
        return totalCloudCover / Double(relevantHours.count)
    }
}
