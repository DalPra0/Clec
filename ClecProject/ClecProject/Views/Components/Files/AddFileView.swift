//
//  AddFileView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddFileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var fileName: String = ""
    @State private var selectedFileType: FileType = .pdf
    @State private var showingFilePicker = false
    @State private var showingDocumentPicker = false
    
    let projectIndex: Int
    
    var isFormValid: Bool {
        !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                header
                
                ScrollView {
                    VStack(spacing: 24) {
                        // File name input
                        fileNameSection
                        
                        // File type picker
                        fileTypeSection
                        
                        // Quick actions
                        quickActionsSection
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // Add button
                addButton
            }
        }
        .sheet(isPresented: $showingDocumentPicker) {
            FileDocumentPicker { url in
                handleDocumentSelection(url: url)
            }
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack {
            Button("Cancelar") {
                dismiss()
            }
            .foregroundColor(.primary)
            
            Spacer()
            
            Text("Adicionar Arquivo")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button("Adicionar") {
                addFile()
            }
            .foregroundColor(isFormValid ? .blue : .secondary)
            .fontWeight(.semibold)
            .disabled(!isFormValid)
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray4)),
            alignment: .bottom
        )
    }
    
    // MARK: - File Name Section
    private var fileNameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nome do Arquivo")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("Ex: Storyboard Cena 1", text: $fileName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 16))
        }
        .padding(.horizontal)
    }
    
    // MARK: - File Type Section
    private var fileTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tipo de Arquivo")
                .font(.headline)
                .foregroundColor(.primary)
            
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
        .padding(.horizontal)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ações Rápidas")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                QuickActionButton(
                    title: "Escolher do Dispositivo",
                    subtitle: "Selecionar arquivo existente",
                    icon: "folder.fill",
                    color: .blue
                ) {
                    showingDocumentPicker = true
                }
                
                QuickActionButton(
                    title: "Criar Documento",
                    subtitle: "Criar novo arquivo de texto",
                    icon: "doc.text.fill",
                    color: .green
                ) {
                    createDocument()
                }
                
                QuickActionButton(
                    title: "Adicionar Referência",
                    subtitle: "Apenas o nome, sem arquivo",
                    icon: "link",
                    color: .orange
                ) {
                    createReference()
                }
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button(action: addFile) {
            HStack {
                Image(systemName: "plus")
                Text("Adicionar Arquivo")
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(isFormValid ? Color.blue : Color.gray)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .disabled(!isFormValid)
    }
    
    // MARK: - Actions
    private func addFile() {
        guard isFormValid else { return }
        
        let trimmedName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        let generatedFileName = "\(trimmedName.lowercased().replacingOccurrences(of: " ", with: "_")).\(selectedFileType.rawValue)"
        
        let newFile = ProjectFile(
            name: trimmedName,
            fileName: generatedFileName,
            fileType: selectedFileType,
            dateAdded: Date(),
            fileSize: generateMockFileSize(),
            isScreenplay: false
        )
        
        projectManager.addFileToProject(at: projectIndex, file: newFile)
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        dismiss()
    }
    
    private func handleDocumentSelection(url: URL) {
        let fileType = FileType.fromFileName(url.lastPathComponent)
        fileName = url.deletingPathExtension().lastPathComponent
        selectedFileType = fileType
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

// MARK: - File Type Button
struct FileTypeButton: View {
    let fileType: FileType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: fileType.colorHex))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: fileType.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(fileType.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Quick Action Button
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
                        .fill(color.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - File Document Picker
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

// MARK: - Preview
#Preview {
    AddFileView(projectIndex: 0)
        .environmentObject(ProjectManager())
}
