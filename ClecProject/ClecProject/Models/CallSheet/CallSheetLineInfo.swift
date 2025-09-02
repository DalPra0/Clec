//
//  CallSheetLineInfo.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import Foundation

struct CallSheetLineInfo: Codable, Identifiable {
    var id = UUID()
    var scene: Int
    var shots: [Int]
    var environmentCondition: EnvironmentConditions
    var location: SceneLocation
    var description: String
    var characters: [SceneCharacter]
    
}
