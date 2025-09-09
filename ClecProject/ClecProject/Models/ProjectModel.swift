//
//  ProjectModel.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 28/08/25.
//

import Foundation
import FirebaseFirestore


struct ProjectModel: Codable, Identifiable {
    @DocumentID var id: String?
    let code: String
    var director: String
    var name: String
    var photo: String?
    var screenPlay: String?
    var deadline: Date?
    var additionalFiles: [ProjectFile]
    var callSheet: [CallSheetModel]
    
    var ownerId: String
    var members: [String]
    
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
        id: String? = nil,
        code: String,
        director: String,
        name: String,
        photo: String? = nil,
        screenPlay: String? = nil,
        deadline: Date? = nil,
        additionalFiles: [ProjectFile] = [],
        callSheet: [CallSheetModel],
        ownerId: String,
        members: [String]
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
        self.ownerId = ownerId
        self.members = members
    }
}
