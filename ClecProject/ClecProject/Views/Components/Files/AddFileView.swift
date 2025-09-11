//
//  AddFileView.swift
//  ClecProject
//
//  Clean design consistent with app design system
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI
import UniformTypeIdentifiers
import PhotosUI

struct AddFileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var projectManager: ProjectManager
    
    @State private var fileName: String = ""
    @State private var showingDocumentPicker = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedDocumentURL: URL?
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    
    let projectIndex: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundDark")
                    .ignoresSafeArea()
                    .dismissKeyboardOnTap()
                
                VStack(spacing: 40) {
                    headerSection
                    
                    Spacer()
                    
                    actionCardsSection
                    
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Loading overlay
                if isUploading {
                    loadingOverlay
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingDocumentPicker) {
            FileDocumentPicker { url in
                handleDocumentSelection(url: url)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                handleImageSelection(image: image)
            }
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(sourceType: .camera) { image in
                handleImageSelection(image: image)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color("CardBackground"))
                        )
                }
                
                Spacer()
                
                Text("Adicionar Arquivo")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Color.clear
                    .frame(width: 44, height: 44)
            }
            
            Text("Escolha como deseja adicionar o arquivo")
                .font(.system(size: 16))
                .foregroundColor(Color("TextSecondary"))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Action Cards Section
    private var actionCardsSection: some View {
        VStack(spacing: 20) {
            // Upload File Card - with Document Asset
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                showingDocumentPicker = true
            }) {
                CroppedAssetCard(
                    assetName: "AssetPersonagemSegurandoOrdemdoDia",
                    title: "Escolher Arquivo",
                    subtitle: "PDFs, documentos, vídeos...",
                    assetOffset: CGSize(width: 20, height: 10),
                    assetScale: 1.3,
                    flipHorizontally: false,
                    shadowColor: Color("PrimaryOrange").opacity(0.2)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Take Photo Card - with Camera Asset (Orange + Flipped)
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                showingCamera = true
            }) {
                CroppedAssetCard(
                    assetName: "AssetPersoagemSegurandoCameraLaranja",
                    title: "Tirar Foto",
                    subtitle: "Capturar com a câmera",
                    assetOffset: CGSize(width: 15, height: 0),
                    assetScale: 1.2,
                    flipHorizontally: true,
                    shadowColor: Color("PrimaryOrange").opacity(0.3)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Photo Library Card - with Claquete Asset (Orange + Flipped)
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                showingImagePicker = true
            }) {
                CroppedAssetCard(
                    assetName: "AssetMaoSegurandoClaqueteLaranja",
                    title: "Galeria de Fotos",
                    subtitle: "Escolher da biblioteca",
                    assetOffset: CGSize(width: 10, height: 5),
                    assetScale: 1.1,
                    flipHorizontally: true,
                    shadowColor: Color("PrimaryOrange").opacity(0.2)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryOrange")))
                    .scaleEffect(1.5)
                
                Text("Adicionando arquivo...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("CardBackground"))
            )
        }
    }
    
    // MARK: - Actions
    private func handleDocumentSelection(url: URL) {
        print("📁 Arquivo selecionado: \\(url.lastPathComponent)")
        
        isUploading = true
        
        // Detectar tipo automaticamente
        let fileType = FileType.fromFileName(url.lastPathComponent)
        let fileName = url.deletingPathExtension().lastPathComponent
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addFileToProject(
                name: fileName,
                fileName: url.lastPathComponent,
                fileType: fileType,
                sourceURL: url
            )
        }
    }
    
    private func handleImageSelection(image: UIImage) {
        print("📷 Imagem capturada/selecionada")
        
        isUploading = true
        
        let fileName = "IMG_\\(Date().timeIntervalSince1970)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addFileToProject(
                name: fileName,
                fileName: "\\(fileName).jpg",
                fileType: .jpg,
                image: image
            )
        }
    }
    
    private func addFileToProject(
        name: String,
        fileName: String,
        fileType: FileType,
        sourceURL: URL? = nil,
        image: UIImage? = nil
    ) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let project = projectManager.projects[projectIndex]
        
        // Create file object
        let newFile = ProjectFile(
            name: trimmedName,
            fileName: fileName,
            fileType: fileType,
            dateAdded: Date(),
            fileSize: generateMockFileSize(),
            isScreenplay: false,
            localURL: nil // Firebase URL will be added later
        )
        
        // Add to project
        projectManager.addFileToProject(at: projectIndex, file: newFile)
        
        print("✅ Arquivo adicionado: \\(newFile.displayName)")
        
        // Haptic feedback
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        isUploading = false
        dismiss()
    }
    
    private func generateMockFileSize() -> String {
        let sizes = ["156 KB", "1.2 MB", "2.8 MB", "534 KB", "3.1 MB", "789 KB", "1.7 MB"]
        return sizes.randomElement() ?? "1.0 MB"
    }
}

// MARK: - Clean Cropped Asset Card Component
struct CroppedAssetCard: View {
    let assetName: String
    let title: String
    let subtitle: String
    let assetOffset: CGSize
    let assetScale: Double
    let flipHorizontally: Bool
    let shadowColor: Color
    
    var body: some View {
        // Simple card following app design system
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("CardBackground"))
            .frame(height: 120)
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            .overlay(
                // Card content
                HStack(spacing: 0) {
                    // Text Content
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("TextSecondary"))
                            .lineSpacing(2)
                        
                        Spacer()
                    }
                    .padding(.leading, 24)
                    .padding(.vertical, 24)
                    
                    Spacer()
                    
                    // Asset - positioned to peek from right side
                    Image(assetName)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(assetScale)
                        .scaleEffect(x: flipHorizontally ? -1 : 1, y: 1) // Horizontal flip
                        .offset(assetOffset)
                        .frame(width: 140, height: 120)
                        .clipped()
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                // Subtle border for definition
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("TextSecondary").opacity(0.1), lineWidth: 1)
            )
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImageSelected: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageSelected(image)
            }
            picker.dismiss(animated: true)
        }
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

#Preview {
    AddFileView(projectIndex: 0)
        .environmentObject(ProjectManager())
}
