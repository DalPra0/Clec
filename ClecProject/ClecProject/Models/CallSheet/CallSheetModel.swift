//
//  ProjectModel.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import Foundation

struct CallSheetModel: Codable, Identifiable {
    let id: UUID
    var day: Date
    var schedule: [SchedulePair]

    
    var sceneTable: [CallSheetLineInfo]
    
    
    enum ScheduleActivity: String, Codable {
        case Begginning = "Início"
        case StartFilming =  "Roda"
        case Lunch = "Almoço"
        case EndFilming = "Encerramento"
        case EndOfRental = "Fim da diária"
    }
}
