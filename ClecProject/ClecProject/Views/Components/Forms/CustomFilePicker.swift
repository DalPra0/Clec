//
//  CustomFilePicker.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct CustomFilePicker: View {
    let title: String
    @Binding var selectedFileName: String?
    @State private var showingDocumentPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Button(action: {
                showingDocumentPicker = true
            }) {
                HStack {
                    if let fileName = selectedFileName {
                        // Arquivo selecionado
                        HStack {
                            Image(systemName: fileIcon)
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(fileName)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                
                                Text(fileTypeText)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        // Nenhum arquivo selecionado
                        HStack {
                            Image(systemName: "doc.badge.plus")
                                .foregroundColor(.secondary)
                            
                            Text("Selecionar arquivo PDF ou DOC")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Botão para remover arquivo
            if selectedFileName != nil {
                HStack {
                    Button(action: {
                        selectedFileName = nil
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Remover arquivo")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 4)
            }
            
            // Tipos de arquivo aceitos
            Text("Formatos aceitos: PDF, DOC, DOCX")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(selectedFileName: $selectedFileName)
        }
    }
    
    // MARK: - Helper Properties
    private var fileIcon: String {
        guard let fileName = selectedFileName else { return "doc" }
        
        let fileExtension = (fileName as NSString).pathExtension.lowercased()
        switch fileExtension {
        case "pdf":
            return "doc.richtext.fill"
        case "doc", "docx":
            return "doc.text.fill"
        default:
            return "doc.fill"
        }
    }
    
    private var fileTypeText: String {
        guard let fileName = selectedFileName else { return "" }
        
        let fileExtension = (fileName as NSString).pathExtension.uppercased()
        return "\(fileExtension) • Roteiro"
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFileName: String?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [
                UTType.pdf,
                UTType(filenameExtension: "doc") ?? UTType.data,
                UTType(filenameExtension: "docx") ?? UTType.data
            ],
            asCopy: true
        )
        
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Pegar apenas o nome do arquivo
            let fileName = url.lastPathComponent
            
            // Validar tipo de arquivo
            let fileExtension = url.pathExtension.lowercased()
            let allowedExtensions = ["pdf", "doc", "docx"]
            
            if allowedExtensions.contains(fileExtension) {
                DispatchQueue.main.async {
                    self.parent.selectedFileName = fileName
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
                print("✅ Arquivo selecionado: \(fileName)")
            } else {
                print("❌ Tipo de arquivo não suportado: \(fileExtension)")
                // TODO: Mostrar alert de erro
            }
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    @State var fileName: String? = nil
    
    return CustomFilePicker(
        title: "Roteiro",
        selectedFileName: $fileName
    )
    .padding()
}
