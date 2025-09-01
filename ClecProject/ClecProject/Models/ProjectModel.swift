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
    var additionalFiles: [ProjectFile] // Nova propriedade para arquivos adicionais
    var callSheet: [CallSheetModel]
    
    // Computed property para o arquivo de roteiro
    var screenplayFile: ProjectFile? {
        guard let screenPlay = screenPlay else { return nil }
        
        let fileType = FileType.fromFileName(screenPlay)
        return ProjectFile(
            name: "Roteiro",
            fileName: screenPlay,
            fileType: fileType,
            dateAdded: Date(), // Poderia ser uma data específica
            isScreenplay: true
        )
    }
    
    // Todos os arquivos (roteiro + adicionais)
    var allFiles: [ProjectFile] {
        var files: [ProjectFile] = []
        
        if let screenplay = screenplayFile {
            files.append(screenplay)
        }
        
        files.append(contentsOf: additionalFiles)
        return files
    }
    
    // Inicializador para compatibilidade com versões antigas
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
