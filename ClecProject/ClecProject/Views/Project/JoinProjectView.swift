//
//  JoinProjectView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI

struct JoinProjectView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Inserir Código")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Insira o código que o assistente\nde direção mandou")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            
            // TODO: Implementar input de código
            // - 4 campos X X X X
            // - Teclado numérico customizado
            // - Validação
            
            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .navigationBarItems(
            leading: Button("Voltar") {
                presentationMode.wrappedValue.dismiss()
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
        .preferredColorScheme(.light)
    }
}

#Preview {
    NavigationView {
        JoinProjectView()
            .environmentObject(ProjectManager())
    }
}
