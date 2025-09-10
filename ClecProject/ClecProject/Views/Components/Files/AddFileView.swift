//
//  AddFileView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

// 🔥 FIREBASE TODO: Esta view é onde acontece o upload dos arquivos
// 🔥   - addFile() precisa ser modificada para fazer upload Firebase
// 🔥   - Adicionar progress indicator durante upload
// 🔥   - Error handling se upload falhar
// 🔥   - Talvez adicionar preview do arquivo antes do upload

import SwiftUI
import UniformTypeIdentifiers

struct AddFileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var fileName: String = ""
    @State private var selectedFileType: FileType = .pdf
    @State private var showingFilePicker = false
    @State private var showingDocumentPicker = false
    @State private var selectedDocumentURL: URL?
    
    let projectIndex: Int
    
    var isFormValid: Bool {
        !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // FUNDO ESCURO CONSISTENTE
                Color(hex: "#141414")
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        fileNameSection
                        
                        fileTypeSection
                        
                        quickActionsSection
                        
                        // Botão Adicionar
                        Button(action: {
                            addFile()
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Adicionar Arquivo")
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        isFormValid ? Color(hex: "#F85601") : Color.gray.opacity(0.3)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }
            .background(Color(hex: "#141414"))
            .colorScheme(.dark)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Voltar")
                                .font(.system(size: 16, weight: .regular))
                        }
                        .foregroundColor(Color(hex: "#F85601"))
                    }
                }
            }
        }
        .colorScheme(.dark)
        .sheet(isPresented: $showingDocumentPicker) {
            FileDocumentPicker { url in
                handleDocumentSelection(url: url)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Adicionar Arquivo")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Adicione roteiros, storyboards\ne outros arquivos do projeto")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color(hex: "#8E8E93"))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var fileNameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Nome do Arquivo")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            TextField("Ex: Storyboard Cena 1", text: $fileName)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#1C1C1E"))
                )
        }
    }
    
    private var fileTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tipo de Arquivo")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(FileType.allCases.filter { $0 != .other }, id: \.self) { fileType in
                    FileTypeButton(
                        fileType: fileType,
                        isSelected: selectedFileType == fileType
                    ) {
                        selectedFileType = fileType
                    }
                }
            }
        }
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ações Rápidas")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                QuickActionButton(
                    title: "Escolher do Dispositivo",
                    subtitle: "Selecionar arquivo existente",
                    icon: "folder.fill",
                    color: Color(hex: "#F85601")
                ) {
                    showingDocumentPicker = true
                }
                
                QuickActionButton(
                    title: "Criar Documento",
                    subtitle: "Criar novo arquivo de texto",
                    icon: "doc.text.fill",
                    color: Color(hex: "#34C759")
                ) {
                    createDocument()
                }
                
                QuickActionButton(
                    title: "Adicionar Referência",
                    subtitle: "Apenas o nome, sem arquivo",
                    icon: "link",
                    color: Color(hex: "#FF9500")
                ) {
                    createReference()
                }
            }
        }
    }
    
    // 🔥 FIREBASE TODO: Esta função é o CORE do sistema de upload! Principais mudanças:
    // 🔥   1. Adicionar @State var isUploading = false, uploadProgress = 0.0
    // 🔥   2. Substituir RealFileManager por Firebase Storage upload
    // 🔥   3. Mostrar loading indicator durante upload
    // 🔥   4. Aguardar upload completar antes de dismiss()
    // 🔥   5. Error handling robusto
    private func addFile() {
        guard isFormValid else { return }
        
        let trimmedName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        let project = projectManager.projects[projectIndex]
        
        if let documentURL = selectedDocumentURL {
            print("📁 Criando arquivo real: \(trimmedName)")
            
            // 🔥 FIREBASE TODO: Substituir tudo abaixo por:
            // uploadToFirebaseStorage(documentURL, projectCode: project.code, fileName: trimmedName)
            
            if documentURL.startAccessingSecurityScopedResource() {
                defer {
                    documentURL.stopAccessingSecurityScopedResource()
                }
                
                if let realFile = ProjectFile.createWithRealFile(
                    name: trimmedName,
                    sourceURL: documentURL,
                    projectCode: project.code,
                    isScreenplay: false
                ) {
                    projectManager.addFileToProject(at: projectIndex, file: realFile)
                    print("✅ Arquivo real adicionado: \(realFile.displayName)")
                    
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                    
                    dismiss()
                    return
                } else {
                    print("❌ Erro ao criar arquivo real")
                }
            }
        }
        
        print("🎨 Criando arquivo mock: \(trimmedName)")
        let generatedFileName = "\(trimmedName.lowercased().replacingOccurrences(of: " ", with: "_")).\(selectedFileType.rawValue)"
        
        let mockFile = ProjectFile(
            name: trimmedName,
            fileName: generatedFileName,
            fileType: selectedFileType,
            dateAdded: Date(),
            fileSize: generateMockFileSize(),
            isScreenplay: false,
            localURL: nil
        )
        
        projectManager.addFileToProject(at: projectIndex, file: mockFile)
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
    
    private func handleDocumentSelection(url: URL) {
        print("📁 Arquivo selecionado: \(url.lastPathComponent)")
        
        let fileType = FileType.fromFileName(url.lastPathComponent)
        fileName = url.deletingPathExtension().lastPathComponent
        selectedFileType = fileType
        
        if url.startAccessingSecurityScopedResource() {
            defer {
                url.stopAccessingSecurityScopedResource()
            }
            
            selectedDocumentURL = url
            
            print("✅ Arquivo preparado para cópia: \(url.lastPathComponent)")
        } else {
            print("❌ Erro: Não foi possível acessar o arquivo selecionado")
        }
    }
    
    private func createDocument() {
        fileName = "Novo Documento"
        selectedFileType = .txt
    }
    
    private func createReference() {
        fileName = "Nova Referência"
        selectedFileType = .other
    }
    
    private func generateMockFileSize() -> String {
        let sizes = ["156 KB", "1.2 MB", "2.8 MB", "534 KB", "3.1 MB", "789 KB", "1.7 MB"]
        return sizes.randomElement() ?? "1.0 MB"
    }
}

struct FileTypeButton: View {
    let fileType: FileType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color(hex: "#F85601") : Color(hex: "#1C1C1E"))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: fileType.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(fileType.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "#F85601") : Color(hex: "#8E8E93"))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "#F85601").opacity(0.1) : Color.clear)
                    .stroke(isSelected ? Color(hex: "#F85601") : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#1C1C1E"))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FileDocumentPicker: UIViewControllerRepresentable {
    let onDocumentSelected: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [
            .pdf, .plainText, .rtf, .image, .video, .audio, .zip, .data
        ])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: FileDocumentPicker
        
        init(_ parent: FileDocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.onDocumentSelected(url)
            }
        }
    }
}
