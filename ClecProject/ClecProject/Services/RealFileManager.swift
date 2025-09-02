//
//  RealFileManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import Foundation

// 🔥 FIREBASE TODO: Renomear arquivo para FirebaseFileManager.swift
// 🔥 FIREBASE TODO: import FirebaseStorage
// 🔥 FIREBASE TODO: import FirebaseAuth (para path do usuário)

class RealFileManager {
    static let shared = RealFileManager()
    
    // 🔥 FIREBASE TODO: Adicionar storage reference
    // private let storage = Storage.storage()
    // private let storageRef = storage.reference()
    
    private init() {
        setupDirectories()
    }
    
    private func setupDirectories() {
        let projectsDir = projectFilesDirectoryURL()
        
        do {
            try FileManager.default.createDirectory(
                at: projectsDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
            print("📁 Diretório de arquivos criado: \(projectsDir.path)")
        } catch {
            print("❌ Erro ao criar diretório: \(error)")
        }
    }
    
    private func projectFilesDirectoryURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsURL.appendingPathComponent("ClecProjectFiles", isDirectory: true)
    }
    
    private func projectDirectoryURL(for projectCode: String) -> URL {
        return projectFilesDirectoryURL().appendingPathComponent(projectCode, isDirectory: true)
    }
    
    // 🔥 FIREBASE TODO: Renomear para uploadFileToFirebase()
    // 🔥 FIREBASE TODO: Em vez de copiar local, fazer upload para Storage
    // 🔥 FIREBASE TODO: Retornar downloadURL do Firebase em vez de localURL
    func copyFileToProject(
        sourceURL: URL,
        projectCode: String,
        fileName: String,
        isScreenplay: Bool = false
    ) -> URL? {
        // 🔥 FIREBASE TODO: Substituir essa lógica toda por:
        // let path = "projects/\(projectCode)/\(isScreenplay ? "screenplay" : "additional")/\(fileName)"
        // let fileRef = storageRef.child(path)
        // fileRef.putFile(from: sourceURL) { metadata, error in ... }
        // return downloadURL
        
        let projectDir = projectDirectoryURL(for: projectCode)
        
        do {
            try FileManager.default.createDirectory(
                at: projectDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            print("❌ Erro ao criar diretório do projeto: \(error)")
            return nil
        }
        
        let subDir = isScreenplay ? "screenplay" : "additional"
        let targetDir = projectDir.appendingPathComponent(subDir, isDirectory: true)
        
        do {
            try FileManager.default.createDirectory(
                at: targetDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            print("❌ Erro ao criar subdiretório: \(error)")
            return nil
        }
        
        let destinationURL = targetDir.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            print("✅ Arquivo copiado: \(fileName) → \(destinationURL.path)")
            return destinationURL
            
        } catch {
            print("❌ Erro ao copiar arquivo: \(error)")
            return nil
        }
    }
    
    // 🔥 FIREBASE TODO: Renomear para deleteFirebaseFile()
    // 🔥 FIREBASE TODO: Em vez de deletar local, deletar do Storage
    // 🔥 FIREBASE TODO: Usar firebasePath em vez de localURL
    func deleteFile(at url: URL) -> Bool {
        // 🔥 FIREBASE TODO: Substituir por:
        // let fileRef = storage.reference(forURL: firebaseURL)
        // fileRef.delete { error in ... }
        
        do {
            try FileManager.default.removeItem(at: url)
            print("🗑️ Arquivo deletado: \(url.lastPathComponent)")
            return true
        } catch {
            print("❌ Erro ao deletar arquivo: \(error)")
            return false
        }
    }
    
    func getFileSize(at url: URL) -> String? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let size = attributes[.size] as? Int64 {
                return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
            }
        } catch {
            print("❌ Erro ao obter tamanho do arquivo: \(error)")
        }
        
        return nil
    }
    
    func fileExists(at localPath: String) -> Bool {
        return FileManager.default.fileExists(atPath: localPath)
    }
    
    func cleanProjectFiles(for projectCode: String) -> Bool {
        let projectDir = projectDirectoryURL(for: projectCode)
        
        do {
            if FileManager.default.fileExists(atPath: projectDir.path) {
                try FileManager.default.removeItem(at: projectDir)
                print("🧹 Arquivos do projeto \(projectCode) limpos")
            }
            return true
        } catch {
            print("❌ Erro ao limpar arquivos do projeto: \(error)")
            return false
        }
    }
    
    func printDirectoryContents() {
        let projectsDir = projectFilesDirectoryURL()
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: projectsDir, includingPropertiesForKeys: nil)
            print("📁 Conteúdo do diretório de arquivos:")
            
            for item in contents {
                print("  - \(item.lastPathComponent)")
            }
        } catch {
            print("❌ Erro ao listar conteúdo: \(error)")
        }
    }
}

// MARK: - ProjectFile Extensions
extension ProjectFile {
    // 🔥 FIREBASE TODO: Renomear para createWithFirebaseFile
    // 🔥 FIREBASE TODO: Em vez de localURL, salvar firebaseURL
    static func createWithRealFile(
        name: String,
        sourceURL: URL,
        projectCode: String,
        isScreenplay: Bool = false
    ) -> ProjectFile? {
        // 🔥 FIREBASE TODO: Aguardar upload completar e pegar downloadURL
        
        let fileName = sourceURL.lastPathComponent
        let fileType = FileType.fromFileName(fileName)
        
        guard let destinationURL = RealFileManager.shared.copyFileToProject(
            sourceURL: sourceURL,
            projectCode: projectCode,
            fileName: fileName,
            isScreenplay: isScreenplay
        ) else {
            print("❌ Falha ao copiar arquivo: \(fileName)")
            return nil
        }
        
        let fileSize = RealFileManager.shared.getFileSize(at: destinationURL)
        
        // 🔥 FIREBASE TODO: Em vez de destinationURL.path, usar downloadURL do Firebase
        // 🔥 FIREBASE TODO: fileSize virá do metadata do upload
        return ProjectFile(
            name: name.isEmpty ? fileName : name,
            fileName: fileName,
            fileType: fileType,
            dateAdded: Date(),
            fileSize: fileSize,
            isScreenplay: isScreenplay,
            localURL: destinationURL.path
        )
    }
    
    func deleteRealFile() -> Bool {
        guard let realURL = realFileURL else { return false }
        return RealFileManager.shared.deleteFile(at: realURL)
    }
}
