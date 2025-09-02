//
//  FilesView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct FilesView: View {
    let projectIndex: Int
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAddFile = false
    @State private var showingRenameAlert = false
    @State private var fileToRename: ProjectFile?
    @State private var newFileName = ""
    @State private var fileToPreview: ProjectFile?
    @State private var previewURL: URL?
    
    private var project: ProjectModel {
        projectManager.projects[projectIndex]
    }
    
    private var hasFiles: Bool {
        project.screenplayFile != nil || !project.additionalFiles.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            if hasFiles {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if let screenplay = project.screenplayFile {
                            screenplaySection(screenplay)
                        }
                        
                        if !project.additionalFiles.isEmpty {
                            additionalFilesSection
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                }
            } else {
                emptyState
            }
            
            addFileButton
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddFile) {
            AddFileView(projectIndex: projectIndex)
                .environmentObject(projectManager)
        }
        .sheet(item: $previewURL) { url in
            QLPreviewView(url: url, fileName: fileToPreview?.displayName ?? "")
        }
        .alert("Renomear Arquivo", isPresented: $showingRenameAlert) {
            TextField("Novo nome", text: $newFileName)
            Button("Cancelar", role: .cancel) {}
            Button("Renomear") {
                renameFile()
            }
        } message: {
            Text("Digite o novo nome para o arquivo:")
        }
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Arquivos")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("\(project.allFiles.count) arquivo\(project.allFiles.count == 1 ? "" : "s")")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(project.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text("Dir: \(project.director)")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
    
    private func screenplaySection(_ screenplay: ProjectFile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "text.book.closed.fill")
                        .foregroundColor(.purple)
                    Text("Roteiro Principal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            FileRowView(file: screenplay, onPreview: {
                openPreview(for: screenplay)
            })
        }
    }
    
    private var additionalFilesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "folder.fill")
                        .foregroundColor(.blue)
                    Text("Arquivos Adicionais")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Text("\(project.additionalFiles.count)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            VStack(spacing: 8) {
                ForEach(project.additionalFiles) { file in
                    FileRowView(
                        file: file,
                        onRemove: {
                            removeFile(file)
                        },
                        onRename: {
                            startRenaming(file)
                        },
                        onPreview: {
                            openPreview(for: file)
                        }
                    )
                }
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "folder")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Nenhum arquivo adicionado")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Adicione arquivos importantes para o projeto como roteiros, storyboards, cronogramas e referências.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var addFileButton: some View {
        Button(action: {
            showingAddFile = true
        }) {
            HStack {
                Image(systemName: "plus")
                Text("Adicionar Arquivo")
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.blue)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Preview Actions  
    // 🔥 FIREBASE TODO: Esta é uma das funções MAIS importantes para Firebase!
    // 🔥   1. Para arquivos Firebase: baixar temporário antes do preview
    // 🔥   2. Adicionar @State var isDownloading = false
    // 🔥   3. Mostrar loading indicator durante download
    // 🔥   4. Cache local dos arquivos baixados  
    // 🔥   5. Error handling se download falhar
    private func openPreview(for file: ProjectFile) {
        print("👁️ Tentando abrir preview para: \(file.displayName)")
        
        fileToPreview = file
        
        // 🔥 FIREBASE TODO: Aqui virá a lógica principal:
        // if file.hasFirebaseFile {
        //     downloadFileAndPreview(file)
        // } else { mock fallback }
        
        if let realURL = file.realFileURL, file.hasRealFile {
            print("✅ Usando arquivo real: \(realURL.lastPathComponent)")
            previewURL = realURL
        }
        else if let mockURL = QLPreviewView.createMockFileURL(for: file) {
            print("🎨 Usando arquivo mock: \(mockURL.lastPathComponent)")
            previewURL = mockURL
        }
        else {
            print("❌ Criando fallback para: \(file.displayName)")
            createFallbackPreview(for: file)
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    // 🔥 FIREBASE TODO: Adicionar esta função para download de arquivos Firebase:
    // private func downloadFileAndPreview(_ file: ProjectFile) {
    //     guard let downloadURL = file.firebaseURL else { return }
    //     isDownloading = true
    //     
    //     // 1. Verificar se já existe no cache
    //     let cacheURL = getCacheURL(for: file)
    //     if FileManager.default.fileExists(atPath: cacheURL.path) {
    //         previewURL = cacheURL
    //         isDownloading = false
    //         return
    //     }
    //     
    //     // 2. Download do Firebase para cache temporário
    //     URLSession.shared.downloadTask(with: URL(string: downloadURL)!) { localURL, response, error in
    //         DispatchQueue.main.async {
    //             isDownloading = false
    //             if let localURL = localURL {
    //                 try? FileManager.default.moveItem(at: localURL, to: cacheURL)
    //                 previewURL = cacheURL
    //             }
    //         }
    //     }.resume()
    // }
    
    private func createFallbackPreview(for file: ProjectFile) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fallbackURL = documentsPath.appendingPathComponent("\(file.displayName).txt")
        
        let fallbackText = """
        📱 CLÉCQUI! - VISUALIZADOR DE ARQUIVOS
        
        📁 Nome: \(file.displayName)
        📄 Arquivo: \(file.fileName)
        🏷️ Tipo: \(file.fileType.displayName)
        📅 Data: \(file.formattedDate)
        📊 Tamanho: \(file.fileSize ?? "N/A")
        
        \(file.isScreenplay ? "🎭 Este é o ROTEIRO principal do projeto." : "")
        
        --------------------------------------------------
        
        Em um aplicativo real, este seria o conteúdo
        do arquivo original carregado pelo usuário.
        
        O QuickLook suporta nativamente:
        • PDFs
        • Imagens (JPG, PNG, HEIC)
        • Documentos do Office (Word, Excel, PowerPoint)
        • Arquivos de texto
        • Apresentações
        • Vídeos e áudios
        • E muito mais!
        
        --------------------------------------------------
        
        Para implementar uploads reais:
        1. Use document picker para seletar arquivos
        2. Copie arquivos para o diretório da app
        3. Armazene URLs reais no ProjectFile
        4. Use essas URLs no QuickLook
        
        🚀 ClecProject - Sistema de Arquivos
        """
        
        do {
            try fallbackText.write(to: fallbackURL, atomically: true, encoding: .utf8)
            previewURL = fallbackURL
            print("✅ Arquivo fallback criado: \(fallbackURL.lastPathComponent)")
        } catch {
            print("❌ Erro ao criar arquivo fallback: \(error)")
        }
    }
    
    private func removeFile(_ file: ProjectFile) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        projectManager.removeFileFromProject(at: projectIndex, fileId: file.id)
    }
    
    private func startRenaming(_ file: ProjectFile) {
        fileToRename = file
        newFileName = file.name
        showingRenameAlert = true
    }
    
    private func renameFile() {
        guard let file = fileToRename,
              !newFileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let updatedFile = ProjectFile(
            id: file.id,
            name: newFileName.trimmingCharacters(in: .whitespacesAndNewlines),
            fileName: file.fileName,
            fileType: file.fileType,
            dateAdded: file.dateAdded,
            fileSize: file.fileSize,
            isScreenplay: file.isScreenplay
        )
        
        projectManager.updateFileInProject(at: projectIndex, updatedFile: updatedFile)
        
        fileToRename = nil
        newFileName = ""
    }
}

#Preview {
    NavigationView {
        FilesView(projectIndex: 0)
            .environmentObject({
                let manager = ProjectManager()
                
                let mockFiles = [
                    ProjectFile(
                        name: "Storyboard Cena 1",
                        fileName: "storyboard_cena1.jpg",
                        fileType: .jpg,
                        fileSize: "2.3 MB"
                    ),
                    ProjectFile(
                        name: "Cronograma de Filmagem",
                        fileName: "cronograma.docx",
                        fileType: .docx,
                        fileSize: "156 KB"
                    ),
                    ProjectFile(
                        name: "Referências Visuais",
                        fileName: "referencias.zip",
                        fileType: .zip,
                        fileSize: "5.2 MB"
                    )
                ]
                
                let project = ProjectModel(
                    code: "TEST",
                    director: "João Silva",
                    name: "Projeto Teste",
                    screenPlay: "roteiro_principal.pdf",
                    additionalFiles: mockFiles,
                    callSheet: []
                )
                
                manager.projects = [project]
                return manager
            }())
    }
}
