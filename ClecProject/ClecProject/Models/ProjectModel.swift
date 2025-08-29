//
//  ProjectModel.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import Foundation


struct ProjectModel: Codable, Identifiable {
    let id: UUID
    let code: String
    var director: String
    var name: String
    var photo: String?
    var screenPlay: String?
    var deadline: Date?
    
    
    var callSheet: [CallSheetModel]
}
