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
            
            FileRowView(file: screenplay)
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
