//
//  SchedulePair.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import Foundation

struct SchedulePair {
    var scheduleActivity: ScheduleActivity
    var time: Date
    
    
    enum ScheduleActivity: String {
        case Begginning = "Início"
        case StartFilming =  "Roda"
        case Lunch = "Almoço"
        case EndFilming = "Encerramento"
        case EndOfRental = "Fim da diária"
    }

}
