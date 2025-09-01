//
//  Developer.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import Foundation

struct DeveloperHelper {
    
    static func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
    
    static func createInterval(hour: Int, minute: Int) -> Date{
        return createDate(year: 0, month: 0, day: 12, hour: hour, minute: minute)
    }

    static let project: ProjectModel = ProjectModel(
        code: "ABCD",
        director: "Munhoz",
        name: "O ataque dos Androids",
        callSheet: [
            CallSheetModel(id: UUID(), day: createDate(year: 2025, month: 12, day: 12, hour: 12, minute: 12), schedule: [SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 4, minute: 30)), SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.EndFilming, time: createInterval(hour: 8, minute: 30))], callSheetColor: CallSheetModel.CallSheetColor.blue, sceneTable: [
                CallSheetLineInfo(scene: 1, shots: [1, 2, 3], environmentCondition: EnvironmentConditions(environment: "INT.", dayCycle: "DAY", weather: "SUNNY"), location: SceneLocation(name: "Ana's Apartment", address: "Rua Visconde de Nácar, 1510", latitude: -25.4352, longitude: -49.2769), description: "Ana discovers the hidden message.", characters: [SceneCharacter(name: "Ana", actor: "Alice Braga")]),
                CallSheetLineInfo(scene: 2, shots: [1], environmentCondition: EnvironmentConditions(environment: "EXT.", dayCycle: "NIGHT", weather: "CLEAR"), location: SceneLocation(name: "Parque Tanguá Overlook", address: "R. Oswaldo Maciel, s/n", latitude: -25.3847, longitude: -49.2903), description: "Beto watches the androids approach.", characters: [SceneCharacter(name: "Beto", actor: "Wagner Moura")])
            ]),
            CallSheetModel(id: UUID(), day: createDate(year: 2025, month: 12, day: 13, hour: 12, minute: 12), schedule: [SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 4, minute: 30)), SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 8, minute: 30))], callSheetColor: CallSheetModel.CallSheetColor.green, sceneTable: [
                CallSheetLineInfo(scene: 5, shots: [1, 2], environmentCondition: EnvironmentConditions(environment: "INT.", dayCycle: "NIGHT", weather: "RAINY"), location: SceneLocation(name: "Industrial Warehouse", address: "Av. das Torres, 5000", latitude: -25.4800, longitude: -49.2200), description: "Ana and Beto confront the lead android.", characters: [SceneCharacter(name: "Ana", actor: "Alice Braga"), SceneCharacter(name: "Beto", actor: "Wagner Moura")])
            ]),
            CallSheetModel(id: UUID(), day: createDate(year: 2025, month: 12, day: 14, hour: 12, minute: 12), schedule: [SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 4, minute: 30)), SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 8, minute: 30))], callSheetColor: CallSheetModel.CallSheetColor.yellow, sceneTable: [
                CallSheetLineInfo(scene: 10, shots: [1, 2, 3, 4], environmentCondition: EnvironmentConditions(environment: "EXT.", dayCycle: "DAY", weather: "CLOUDY"), location: SceneLocation(name: "Rua XV de Novembro", address: "Rua XV de Novembro, Centro", latitude: -25.4295, longitude: -49.2719), description: "Final chase sequence.", characters: [SceneCharacter(name: "Ana", actor: "Alice Braga"), SceneCharacter(name: "Beto", actor: "Wagner Moura")]),
                CallSheetLineInfo(scene: 11, shots: [1], environmentCondition: EnvironmentConditions(environment: "INT.", dayCycle: "DAY", weather: "SUNNY"), location: SceneLocation(name: "Lucca Cafés Especiais", address: "Alameda Pres. Taunay, 40", latitude: -25.4328, longitude: -49.2820), description: "The heroes celebrate their victory.", characters: [SceneCharacter(name: "Ana", actor: "Alice Braga"), SceneCharacter(name: "Beto", actor: "Wagner Moura")])
            ])
        ]
    )
}
