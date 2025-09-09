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
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Button(action: {
                showingDocumentPicker = true
            }) {
                HStack {
                    if let fileName = selectedFileName {
                        HStack(spacing: 12) {
                            Image(systemName: fileIcon)
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#F85601"))
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(fileName)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                                Text(fileTypeText)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#8E8E93"))
                            }
                        }
                    } else {
                        HStack(spacing: 12) {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#F85601"))
                                .frame(width: 20)
                            
                            Text("Selecionar arquivo PDF ou DOC")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(hex: "#8E8E93"))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1C1C1E"))
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if selectedFileName != nil {
                Button(action: {
                    selectedFileName = nil
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                        
                        Text("Remover arquivo")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 8)
            }
            
            Text("Formatos aceitos: PDF, DOC, DOCX")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#8E8E93"))
                .padding(.top, 4)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            DocumentPicker(selectedFileName: $selectedFileName)
        }
    }
    
    private var fileIcon: String {
        guard let fileName = selectedFileName else { return "doc.badge.plus" }
        
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
            
            let fileName = url.lastPathComponent
            
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
    @Previewable @State var fileName: String? = nil
    
    return VStack(spacing: 20) {
        CustomFilePicker(
            title: "Roteiro",
            selectedFileName: $fileName
        )
    }
    .padding()
    .background(Color(hex: "#141414"))
}
