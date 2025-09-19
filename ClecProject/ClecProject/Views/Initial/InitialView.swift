import SwiftUI

struct InitialView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
    @State private var showingCreateProject = false
    @State private var showingJoinProject = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fundo preto total
                Color.black
                    .ignoresSafeArea()
                
                // RETÂNGULO DE FUNDO MAIS ALTO - vai mais pra cima
                VStack {
                    Spacer()
                        .frame(height: 160)
                    
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color(red: 0.09, green: 0.09, blue: 0.1))
                        .ignoresSafeArea(edges: .bottom)
                }
                .zIndex(1)
                
                // Conteúdo principal
                VStack(spacing: 0) {
                    // Spacer do topo
                    Spacer()
                        .frame(height: 60)
                    
                    // Título + Subtítulo
                    VStack(spacing: 12) {
                        Text("Bem vindo!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Você pode escolher criar um projeto\nou entrar em um com código")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    
                    // Espaço entre título e cards
                    Spacer()
                        .frame(height: 50)
                    
                    // Cards Section - ESTRUTURA IGUAL AO CROPPEDCARD
                    VStack(spacing: 32) {
                        // Card Criar Projeto - ALTURA FIXA como no AddFileView
                        Button(action: { showingCreateProject = true }) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.08, green: 0.08, blue: 0.08))
                                .frame(height: 140) // ALTURA MAIOR
                                .overlay(
                                    // Card content
                                    HStack(spacing: 0) {
                                        // Text Content - MAIS ESPAÇO
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Criar um Projeto")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color("PrimaryOrange"))
                                                .lineLimit(1)
                                            
                                            Text("Eu sou assistente\nde direção")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                        .frame(maxWidth: 200, alignment: .leading)
                                        .padding(.leading, 24)
                                        .padding(.trailing, 16)
                                        .padding(.vertical, 24)
                                        
                                        // Asset - IMAGEM MAIOR
                                        Image("AssetMaoSegurandoClaqueteLaranja")
                                            .resizable()
                                            .scaledToFit()
                                            .scaleEffect(1.4)
                                            .scaleEffect(x: -1, y: 1)
                                            .offset(CGSize(width: 25, height: 10))
                                            .frame(width: 130, height: 140)
                                            .clipped()
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16)) // CLIPPED como no AddFileView
                        }
                        
                        // Card Entrar em Projeto - ALTURA FIXA como no AddFileView
                        Button(action: { showingJoinProject = true }) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.08, green: 0.08, blue: 0.08))
                                .frame(height: 140) // ALTURA MAIOR
                                .overlay(
                                    // Card content
                                    HStack(spacing: 0) {
                                        // Text Content - MAIS ESPAÇO
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Você tem um código?")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(Color("PrimaryOrange"))
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                            
                                            Text("Sou membro do\nset de produção")
                                                .font(.system(size: 16, weight: .regular))
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                        }
                                        .frame(maxWidth: 200, alignment: .leading)
                                        .padding(.leading, 24)
                                        .padding(.trailing, 16)
                                        .padding(.vertical, 24)
                                        
                                        // Asset - IMAGEM MAIOR
                                        Image("AssetPersoagemSegurandoCameraLaranja")
                                            .resizable()
                                            .scaledToFit()
                                            .scaleEffect(1.4)
                                            .scaleEffect(x: -1, y: 1)
                                            .offset(CGSize(width: 20, height: 0))
                                            .frame(width: 130, height: 140)
                                            .clipped()
                                    }
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16)) // CLIPPED como no AddFileView
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .zIndex(2)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingCreateProject) {
            CreateProjectView(onProjectCreated: { project in
                projectManager.setActiveProject(project)
                userManager.updateActiveProject(project.id)
                showingCreateProject = false
            })
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
        .sheet(isPresented: $showingJoinProject) {
            JoinProjectView(onProjectJoined: { project in
                projectManager.setActiveProject(project)
                userManager.updateActiveProject(project.id)
                showingJoinProject = false
            })
            .environmentObject(projectManager)
            .environmentObject(userManager)
        }
    }
}

#Preview {
    InitialView()
        .environmentObject(ProjectManager())
        .environmentObject(UserManager())
}
