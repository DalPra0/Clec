//
//  MovieSearchView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 31/08/25.
//

import SwiftUI

struct MovieSearchView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var viewModel = MovieSearchViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchHeader
                
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                    emptyStateView
                } else if viewModel.searchResults.isEmpty {
                    initialStateView
                } else {
                    searchResultsView
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: EmptyView()
            )
        }
    }
    
    private var searchHeader: some View {
        VStack(spacing: 16) {
            HStack {
                Text(viewModel.apiStatus)
                    .font(.caption)
                    .foregroundColor(TMDbService.shared.isUsingRealAPI ? .green : .orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        (TMDbService.shared.isUsingRealAPI ? Color.green : Color.orange).opacity(0.1)
                    )
                    .cornerRadius(12)
                
                Spacer()
                
                if !TMDbService.shared.isUsingRealAPI {
                    Button("Ver instruções API") {
                        showAPIInstructions()
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 18))
                
                TextField("Buscar filmes...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16))
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 18))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            if !userManager.canAddFavoriteMovie {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.orange)
                    Text("Você já tem 4 filmes favoritos. Remova um para adicionar outro.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(.primary)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Procurando filmes...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.fill")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("Nenhum filme encontrado")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Tente pesquisar por outro título")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var initialStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "popcorn.fill")
                .font(.system(size: 60))
                .foregroundColor(.purple.opacity(0.7))
            
            VStack(spacing: 8) {
                Text("Encontre seus filmes favoritos")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Digite o nome de um filme na barra de busca acima")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Sugestões populares:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(["Pulp Fiction", "Forrest Gump", "Clube da Luta", "Matrix"], id: \.self) { suggestion in
                        Button(suggestion) {
                            viewModel.searchText = suggestion
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.purple.opacity(0.7))
                        .cornerRadius(20)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 30)
    }
    
    private var searchResultsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.searchResults) { movie in
                    MovieSearchRow(
                        movie: movie,
                        canAdd: userManager.canAddFavoriteMovie,
                        isAlreadyFavorite: userManager.isMovieInFavorites(movie)
                    ) {
                        addMovie(movie)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
    
    private func addMovie(_ movie: Movie) {
        userManager.addFavoriteMovie(movie)
        
        if userManager.hasAllFavoriteSlots {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func showAPIInstructions() {
        let alert = UIAlertController(
            title: "🔑 Configurar API TMDb",
            message: "Para busca REAL de filmes:\n\n1. Crie conta gratuita em:\nwww.themoviedb.org/signup\n\n2. Vá em Settings → API\n\n3. Copie sua API Key\n\n4. Cole em TMDbService.swift\n\nNo momento está usando dados demo.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

struct MovieSearchRow: View {
    let movie: Movie
    let canAdd: Bool
    let isAlreadyFavorite: Bool
    let onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 60, height: 90)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let overview = movie.overview, !overview.isEmpty {
                    Text(overview)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: onAdd) {
                if isAlreadyFavorite {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                } else {
                    Image(systemName: canAdd ? "plus.circle.fill" : "plus.circle")
                        .font(.title2)
                        .foregroundColor(canAdd ? .purple : .gray)
                }
            }
            .disabled(!canAdd || isAlreadyFavorite)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    MovieSearchView()
        .environmentObject(UserManager())
}
