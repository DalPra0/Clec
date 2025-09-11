import SwiftUI

struct InitialView: View {
    @EnvironmentObject var projectManager: ProjectManager
    @EnvironmentObject var userManager: UserManager
    
    @State private var showingCreateProject = false
    @State private var showingJoinProject = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Fundo principal
                Color(hex: "#141414")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Título
                    Text("Bem vindo!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    // Subtítulo
                    Text("Você pode escolher criar um projeto\nou entrar em um com código")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    // Cards independentes
                    VStack(spacing: 20) {
                        // Card Criar Projeto
                        Button(action: { showingCreateProject = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Criar um Projeto")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(hex: "#F85601"))
                                    
                                    Text("Eu sou assistente de direção")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                                Image("AssetMaoSegurandoClaqueteLaranja")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 160)
                                    .scaleEffect(x: -1, y: 1)
                                    .offset(x: 20)
                            }
                            .padding()
                            .background(Color(hex: "#1C1C1E"))
                            .cornerRadius(16)
                        }
                        
                        // Card Entrar em Projeto
                        Button(action: { showingJoinProject = true }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Você tem um código?")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color(hex: "#F85601"))
                                    
                                    Text("Sou membro do set de produção")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                                Image("AssetPersoagemSegurandoCameraLaranja")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 160)
                                    .scaleEffect(x: -1, y: 1)
                                    .offset(x: 20)
                            }
                            .padding()
                            .background(Color(hex: "#1C1C1E"))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                // 🔥 Fundo arredondado atrás, independente dos cards
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 32)
                        .fill(Color(hex: "#1C1C1E"))
                        .frame(height: 350) // ajusta a altura do bloco de fundo
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
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
