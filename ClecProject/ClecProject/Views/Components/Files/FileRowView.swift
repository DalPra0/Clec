//
//  FileRowView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 01/09/25.
//

import SwiftUI

struct FileRowView: View {
    let file: ProjectFile
    let onRemove: (() -> Void)?
    let onRename: (() -> Void)?
    
    @State private var showingActionSheet = false
    
    init(file: ProjectFile, onRemove: (() -> Void)? = nil, onRename: (() -> Void)? = nil) {
        self.file = file
        self.onRemove = onRemove
        self.onRename = onRename
    }
    
    var body: some View {
        HStack(spacing: 16) {
            fileIconView
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(file.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if file.isScreenplay {
                        Text("ROTEIRO")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.purple)
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Text(file.fileType.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(file.formattedDate)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let fileSize = file.fileSize {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(fileSize)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            
            if !file.isScreenplay {
                actionButton
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text(file.displayName),
                message: Text("O que você gostaria de fazer com este arquivo?"),
                buttons: [
                    .default(Text("Renomear")) {
                        onRename?()
                    },
                    .destructive(Text("Remover")) {
                        onRemove?()
                    },
                    .cancel(Text("Cancelar"))
                ]
            )
        }
    }
    
    private var fileIconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: file.fileColor))
                .frame(width: 48, height: 48)
            
            Image(systemName: file.fileIcon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
        }
    }
    
    private var actionButton: some View {
        Button(action: {
            showingActionSheet = true
        }) {
            Image(systemName: "ellipsis")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 32, height: 32)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        FileRowView(
            file: ProjectFile(
                name: "Roteiro",
                fileName: "roteiro_principal.pdf",
                fileType: .pdf,
                isScreenplay: true
            )
        )
        
        FileRowView(
            file: ProjectFile(
                name: "Storyboard Cena 1",
                fileName: "storyboard_cena1.jpg",
                fileType: .jpg,
                fileSize: "2.3 MB"
            ),
            onRemove: {},
            onRename: {}
        )
        
        FileRowView(
            file: ProjectFile(
                name: "Cronograma",
                fileName: "cronograma_filmagem.docx",
                fileType: .docx,
                fileSize: "156 KB"
            ),
            onRemove: {},
            onRename: {}
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
