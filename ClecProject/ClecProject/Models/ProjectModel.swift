//
//  ProjectModel.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import Foundation


struct ProjectModel: Codable, Identifiable {
    var id: UUID = UUID()
    let code: String
    var director: String
    var name: String
    var photo: String?
    var screenPlay: String?
    var deadline: Date?
    var additionalFiles: [ProjectFile]
    var callSheet: [CallSheetModel]
    
    var screenplayFile: ProjectFile? {
        guard let screenPlay = screenPlay else { return nil }
        
        let fileType = FileType.fromFileName(screenPlay)
        return ProjectFile(
            name: "Roteiro",
            fileName: screenPlay,
            fileType: fileType,
            dateAdded: Date(),
            isScreenplay: true
        )
    }
    
    var allFiles: [ProjectFile] {
        var files: [ProjectFile] = []
        
        if let screenplay = screenplayFile {
            files.append(screenplay)
        }
        
        files.append(contentsOf: additionalFiles)
        return files
    }
    
    init(
        id: UUID = UUID(),
        code: String,
        director: String,
        name: String,
        photo: String? = nil,
        screenPlay: String? = nil,
        deadline: Date? = nil,
        additionalFiles: [ProjectFile] = [],
        callSheet: [CallSheetModel]
    ) {
        self.id = id
        self.code = code
        self.director = director
        self.name = name
        self.photo = photo
        self.screenPlay = screenPlay
        self.deadline = deadline
        self.additionalFiles = additionalFiles
        self.callSheet = callSheet
    }
}
