//
//  ProjectModel.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import Foundation
import SwiftUICore

struct CallSheetModel: Codable, Identifiable {
    let id: UUID
    var day: Date
    var schedule: [SchedulePair]
    var callSheetColor: CallSheetColor

    
    var sceneTable: [CallSheetLineInfo]
    
    
    func getStartTime() -> Date? {
        return schedule.first?.time
    }
        
    func getEndTime() -> Date? {
        return schedule.last?.time
    }
    
    func getLocation() -> SceneLocation? {
        return sceneTable.first?.location
    }
    
    enum CallSheetColor: String, Codable {
        case green = "#8DFFBE"
        case yellow = "#FFD590"
        case blue = "#8DD1FF"
        case purple = "#A699FF"
        
        var swiftUIColor: Color {
            return Color(hex: self.rawValue)
        }
    }
    
    enum ScheduleActivity: String, Codable {
        case Begginning = "Início"
        case StartFilming =  "Roda"
        case Lunch = "Almoço"
        case EndFilming = "Encerramento"
        case EndOfRental = "Fim da diária"
    }
}
