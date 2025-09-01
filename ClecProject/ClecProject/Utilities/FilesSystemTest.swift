//
//  FilesSystemTest.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import Foundation

// MARK: - Quick Test for Files System
struct FilesSystemTest {
    
    // Test creating a file
    static func testFileCreation() {
        let testFile = ProjectFile(
            name: "Teste",
            fileName: "teste.pdf",
            fileType: .pdf,
            fileSize: "1.0 MB"
        )
        
        print("✅ Arquivo criado: \(testFile.displayName)")
        print("📄 Tipo: \(testFile.fileType.displayName)")
        print("🎨 Cor: \(testFile.fileColor)")
        print("📅 Data: \(testFile.formattedDate)")
    }
    
    // Test file type detection
    static func testFileTypeDetection() {
        let testFiles = [
            "roteiro.pdf",
            "storyboard.jpg",
            "cronograma.docx",
            "trilha.mp3",
            "referencias.zip",
            "notas.txt"
        ]
        
        for fileName in testFiles {
            let fileType = FileType.fromFileName(fileName)
            print("📁 \(fileName) → \(fileType.displayName) (\(fileType.icon))")
        }
    }
    
    // Test project with files
    static func testProjectWithFiles() {
        let files = [
            ProjectFile(name: "Storyboard", fileName: "story.jpg", fileType: .jpg),
            ProjectFile(name: "Cronograma", fileName: "schedule.pdf", fileType: .pdf)
        ]
        
        let project = ProjectModel(
            code: "TEST",
            director: "Diretor Teste",
            name: "Projeto Teste",
            screenPlay: "roteiro.pdf",
            additionalFiles: files,
            callSheet: []
        )
        
        print("🎬 Projeto: \(project.name)")
        print("📚 Total de arquivos: \(project.allFiles.count)")
        
        if let screenplay = project.screenplayFile {
            print("🎭 Roteiro: \(screenplay.displayName)")
        }
        
        print("📁 Arquivos adicionais: \(project.additionalFiles.count)")
        
        for file in project.additionalFiles {
            print("  - \(file.displayName) (\(file.fileType.displayName))")
        }
    }
}

// MARK: - Run Tests
#if DEBUG
extension FilesSystemTest {
    static func runAllTests() {
        print("\n🧪 === TESTE DO SISTEMA DE ARQUIVOS ===")
        print("\n1️⃣ Teste de Criação de Arquivo:")
        testFileCreation()
        
        print("\n2️⃣ Teste de Detecção de Tipo:")
        testFileTypeDetection()
        
        print("\n3️⃣ Teste de Projeto com Arquivos:")
        testProjectWithFiles()
        
        print("\n✅ === TODOS OS TESTES CONCLUÍDOS ===\n")
    }
}
#endif
