//
//  QLPreviewView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI
import QuickLook

struct QLPreviewView: UIViewControllerRepresentable {
    let url: URL
    let fileName: String
    
    init(url: URL, fileName: String = "") {
        self.url = url
        self.fileName = fileName
    }
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator
        
        controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: context.coordinator,
            action: #selector(Coordinator.doneButtonTapped)
        )
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
        let parent: QLPreviewView
        var dismissHandler: (() -> Void)?
        
        init(parent: QLPreviewView) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as QLPreviewItem
        }
        
        func previewControllerWillDismiss(_ controller: QLPreviewController) {
            print("📖 Preview será fechado para: \(parent.fileName)")
        }
        
        func previewControllerDidDismiss(_ controller: QLPreviewController) {
            print("📖 Preview foi fechado para: \(parent.fileName)")
        }
        
        @objc func doneButtonTapped() {
        }
    }
}

extension QLPreviewView {
    static func createMockFileURL(for file: ProjectFile) -> URL? {
        
        let fileName = file.fileName
        
        switch file.fileType {
        case .pdf:
            return createMockPDFURL(fileName: fileName)
        case .jpg, .jpeg, .png:
            return createMockImageURL(fileName: fileName)
        case .txt:
            return createMockTextURL(fileName: fileName)
        default:
            return createMockGenericURL(fileName: fileName)
        }
    }
    
    private static func createMockPDFURL(fileName: String) -> URL? {
        guard let url = URL(string: "https://www.w3.org/WAI/WCAG21/working-examples/pdf-table/table.pdf") else {
            return Bundle.main.url(forResource: "sample", withExtension: "pdf")
        }
        return url
    }
    
    private static func createMockImageURL(fileName: String) -> URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mockURL = documentsPath.appendingPathComponent(fileName)
        
        if let image = createSimpleImage() {
            let data = image.pngData()
            try? data?.write(to: mockURL)
            return mockURL
        }
        
        return nil
    }
    
    private static func createMockTextURL(fileName: String) -> URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mockURL = documentsPath.appendingPathComponent(fileName)
        
        let sampleText = """
        📄 ARQUIVO DE DEMONSTRAÇÃO
        
        Este é um arquivo de texto de exemplo para demonstrar
        a funcionalidade de visualização de arquivos do ClecProject.
        
        🎬 Nome do Arquivo: \(fileName)
        📅 Data de Criação: \(Date().formatted())
        
        Em um aplicativo real, este seria o conteúdo
        real do arquivo selecionado pelo usuário.
        
        ✨ O QuickLook suporta muitos formatos:
        • PDF
        • Imagens (JPG, PNG, HEIC)
        • Documentos (DOC, DOCX)
        • Planilhas (XLS, XLSX)
        • Apresentações (PPT, PPTX)
        • Arquivos de texto
        • E muito mais!
        """
        
        try? sampleText.write(to: mockURL, atomically: true, encoding: .utf8)
        return mockURL
    }
    
    private static func createMockGenericURL(fileName: String) -> URL? {
        return createMockTextURL(fileName: fileName)
    }
    
    private static func createSimpleImage() -> UIImage? {
        let size = CGSize(width: 400, height: 300)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { context in
            let colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil)!
            
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            let text = "🎬 ClecProject\nArquivo de Exemplo"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.white,
                .strokeWidth: -2,
                .strokeColor: UIColor.black.withAlphaComponent(0.3)
            ]
            
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        return image
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { self.absoluteString }
}

#Preview {
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let sampleURL = documentsPath.appendingPathComponent("sample.txt")
    
    return QLPreviewView(url: sampleURL, fileName: "sample.txt")
}
