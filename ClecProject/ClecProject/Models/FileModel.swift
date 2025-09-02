//
//  FileModel.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

// 🔥 FIREBASE TODO: Este arquivo é o modelo principal dos arquivos
// 🔥 FIREBASE TODO: Principais mudanças necessárias:
// 🔥   - localURL → firebaseURL (downloadURL do Firebase)
// 🔥   - Adicionar firebasePath (caminho no Storage)
// 🔥   - realFileURL() → firebaseFileURL() 
// 🔥   - hasRealFile → hasFirebaseFile
// 🔥   - calculatedFileSize pode vir do metadata do Firebase

import Foundation

struct ProjectFile: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var fileName: String
    var fileType: FileType
    var dateAdded: Date
    var fileSize: String?
    var isScreenplay: Bool
    var localURL: String? // 🔥 FIREBASE TODO: Renomear para firebaseURL: String?
    
    // 🔥 FIREBASE TODO: Adicionar campos do Firebase:
    // var firebasePath: String? // path no Storage (projects/AB12/additional/foto.jpg)
    // var downloadURL: String? // URL direta para download
    // var uploadedBy: String? // userId de quem fez upload
    
    init(
        id: UUID = UUID(),
        name: String,
        fileName: String,
        fileType: FileType,
        dateAdded: Date = Date(),
        fileSize: String? = nil,
        isScreenplay: Bool = false,
        localURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.fileName = fileName
        self.fileType = fileType
        self.dateAdded = dateAdded
        self.fileSize = fileSize
        self.isScreenplay = isScreenplay
        self.localURL = localURL
    }
    
    var displayName: String {
        return name.isEmpty ? fileName : name
    }
    
    var fileIcon: String {
        return fileType.icon
    }
    
    var fileColor: String {
        return fileType.colorHex
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateAdded)
    }
    
    var realFileURL: URL? {
        guard let localURL = localURL else { return nil }
        return URL(fileURLWithPath: localURL)
    }
    
    var hasRealFile: Bool {
        guard let url = realFileURL else { return false }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    var calculatedFileSize: String? {
        if let savedSize = fileSize {
            return savedSize
        }
        
        guard let url = realFileURL,
              let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? Int64 else {
            return nil
        }
        
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}

enum FileType: String, CaseIterable, Codable {
    case pdf = "pdf"
    case doc = "doc"
    case docx = "docx"
    case txt = "txt"
    case rtf = "rtf"
    case pages = "pages"
    case jpg = "jpg"
    case jpeg = "jpeg"
    case png = "png"
    case heic = "heic"
    case mp4 = "mp4"
    case mov = "mov"
    case avi = "avi"
    case mp3 = "mp3"
    case wav = "wav"
    case m4a = "m4a"
    case zip = "zip"
    case rar = "rar"
    case other = "other"
    
    var icon: String {
        switch self {
        case .pdf:
            return "doc.fill"
        case .doc, .docx, .rtf, .pages:
            return "doc.text.fill"
        case .txt:
            return "doc.plaintext.fill"
        case .jpg, .jpeg, .png, .heic:
            return "photo.fill"
        case .mp4, .mov, .avi:
            return "video.fill"
        case .mp3, .wav, .m4a:
            return "music.note"
        case .zip, .rar:
            return "archivebox.fill"
        case .other:
            return "doc.fill"
        }
    }
    
    var colorHex: String {
        switch self {
        case .pdf:
            return "#FF6B6B"
        case .doc, .docx, .pages:
            return "#4ECDC4"
        case .rtf, .txt:
            return "#45B7D1"
        case .jpg, .jpeg, .png, .heic:
            return "#96CEB4"
        case .mp4, .mov, .avi:
            return "#FFEAA7"
        case .mp3, .wav, .m4a:
            return "#DDA0DD"
        case .zip, .rar:
            return "#98D8C8"
        case .other:
            return "#BDC3C7"
        }
    }
    
    var displayName: String {
        switch self {
        case .pdf: return "PDF"
        case .doc: return "DOC"
        case .docx: return "DOCX"
        case .txt: return "TXT"
        case .rtf: return "RTF"
        case .pages: return "PAGES"
        case .jpg, .jpeg: return "JPEG"
        case .png: return "PNG"
        case .heic: return "HEIC"
        case .mp4: return "MP4"
        case .mov: return "MOV"
        case .avi: return "AVI"
        case .mp3: return "MP3"
        case .wav: return "WAV"
        case .m4a: return "M4A"
        case .zip: return "ZIP"
        case .rar: return "RAR"
        case .other: return "FILE"
        }
    }
    
    static func fromFileName(_ fileName: String) -> FileType {
        let lowercased = fileName.lowercased()
        let components = lowercased.split(separator: ".")
        
        guard let extension_ = components.last else {
            return .other
        }
        
        return FileType(rawValue: String(extension_)) ?? .other
    }
}

enum FileCategory: String, CaseIterable {
    case screenplay = "Roteiro"
    case documents = "Documentos"
    case images = "Imagens"
    case videos = "Vídeos"
    case audio = "Áudio"
    case other = "Outros"
    
    var icon: String {
        switch self {
        case .screenplay: return "text.book.closed.fill"
        case .documents: return "doc.fill"
        case .images: return "photo.fill"
        case .videos: return "video.fill"
        case .audio: return "music.note"
        case .other: return "folder.fill"
        }
    }
    
    func matches(fileType: FileType) -> Bool {
        switch self {
        case .screenplay:
            return false
        case .documents:
            return [.pdf, .doc, .docx, .txt, .rtf, .pages].contains(fileType)
        case .images:
            return [.jpg, .jpeg, .png, .heic].contains(fileType)
        case .videos:
            return [.mp4, .mov, .avi].contains(fileType)
        case .audio:
            return [.mp3, .wav, .m4a].contains(fileType)
        case .other:
            return [.zip, .rar, .other].contains(fileType)
        }
    }
}
