//
//  MovieSearchViewModel.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 31/08/25.
//

import Foundation
import Combine
import SwiftUI

class MovieSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingMovieSearch: Bool = false
    @Published var apiStatus: String = ""
    
    private let tmdbService = TMDbService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchDebounce()
        checkAPIStatus()
    }
    
    // MARK: - API Status Check
    private func checkAPIStatus() {
        if tmdbService.isUsingRealAPI {
            apiStatus = "🔄 Testando API..."
            
            tmdbService.testAPIKey()
                .sink { isValid in
                    self.apiStatus = isValid ? "✅ API Real Ativa" : "❌ API Key Inválida"
                }
                .store(in: &cancellables)
        } else {
            apiStatus = "🎭 Modo Demo (sem API key)"
        }
    }
    
    // MARK: - Search Setup
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                if searchText.isEmpty {
                    self?.searchResults = []
                    self?.errorMessage = nil
                } else {
                    self?.searchMovies(query: searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Search Movies (AGORA USA API REAL!)
    private func searchMovies(query: String) {
        isLoading = true
        errorMessage = nil
        
        print("🔍 Iniciando busca por: '\(query)'")
        
        tmdbService.searchMovies(query: query)
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                            self?.searchResults = []
                            print("❌ Erro na busca: \(error.localizedDescription)")
                        }
                    }
                },
                receiveValue: { [weak self] movies in
                    DispatchQueue.main.async {
                        self?.searchResults = movies
                        self?.isLoading = false
                        print("✅ Busca concluída: \(movies.count) filmes encontrados")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Load Popular Movies
    func loadPopularMovies() {
        isLoading = true
        errorMessage = nil
        
        tmdbService.getPopularMovies()
            .sink(
                receiveCompletion: { [weak self] completion in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        
                        if case .failure(let error) = completion {
                            self?.errorMessage = error.localizedDescription
                            print("❌ Erro ao carregar populares: \(error)")
                        }
                    }
                },
                receiveValue: { [weak self] movies in
                    DispatchQueue.main.async {
                        self?.searchResults = movies
                        self?.searchText = "" // Clear search to show popular results
                        print("✅ Filmes populares carregados: \(movies.count)")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Clear Search
    func clearSearch() {
        searchText = ""
        searchResults = []
        errorMessage = nil
        isLoading = false
    }
    
    // MARK: - Show/Hide Search
    func showMovieSearch() {
        showingMovieSearch = true
        clearSearch()
        checkAPIStatus() // Refresh API status when opening
    }
    
    func hideMovieSearch() {
        showingMovieSearch = false
        clearSearch()
    }
    
    // MARK: - Refresh API Status
    func refreshAPIStatus() {
        checkAPIStatus()
    }
}
