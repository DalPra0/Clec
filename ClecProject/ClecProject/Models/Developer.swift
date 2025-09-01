//
//  Developer.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
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

    // Main project data for debugging and previews
    static let project: ProjectModel = ProjectModel(
        code: "ABCD",
        director: "Munhoz",
        name: "O ataque dos Androids",
        callSheet: [
            CallSheetModel(id: UUID(), day: createDate(year: 2025, month: 12, day: 12, hour: 12, minute: 12), schedule: [SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 4, minute: 30)), SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 8, minute: 30))], sceneTable: []),
            CallSheetModel(id: UUID(), day: createDate(year: 2025, month: 12, day: 13, hour: 12, minute: 12), schedule: [SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 4, minute: 30)), SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 8, minute: 30))], sceneTable: []),
            CallSheetModel(id: UUID(), day: createDate(year: 2025, month: 12, day: 14, hour: 12, minute: 12), schedule: [SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 4, minute: 30)), SchedulePair(scheduleActivity: SchedulePair.ScheduleActivity.Begginning, time: createInterval(hour: 8, minute: 30))], sceneTable: [])
        ]
    )
}
