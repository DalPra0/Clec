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
    var schedule: Dictionary<ScheduleActivity, Date>
    
    var sceneTable: [CallSheetLineInfo]
    
    
    enum ScheduleActivity: String, Codable {
        case Beginning = "Início"
        case StartFilming =  "Roda"
        case Lunch = "Almoço"
        case EndFilming = "Encerramento"
        case EndOfRental = "Fim da diária"
    }
}
