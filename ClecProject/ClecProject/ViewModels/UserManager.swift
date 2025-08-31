//
//  UserManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @Published var userName: String = "Nome padrão"
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var favoriteMovies: [FavoriteMovie] = []
    @Published var profileImageData: Data?
    
    private let userDefaults = UserDefaults.standard
    
    private let userNameKey = "UserName"
    private let userEmailKey = "UserEmail"
    private let userPasswordKey = "UserPassword"
    private let favoriteMoviesKey = "FavoriteMovies"
    private let profileImageKey = "ProfileImageData"
    
    var canAddFavoriteMovie: Bool {
        return favoriteMovies.count < 4
    }
    
    var hasAllFavoriteSlots: Bool {
        return favoriteMovies.count >= 4
    }
    
    init() {
        loadUserData()
    }
    
    func updateUserName(_ name: String) {
        userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        saveUserData()
        print("👤 Nome do usuário atualizado para: \(userName)")
    }
    
    var greeting: String {
        return "Hello, \(userName)!"
    }
    
    func updateUserEmail(_ email: String) {
        userEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        saveUserData()
        print("📧 Email atualizado para: \(userEmail)")
    }
    
    func updateUserPassword(_ password: String) {
        userPassword = password
        saveUserData()
        print("🔒 Senha atualizada")
    }
    
    func updateProfileImage(_ imageData: Data?) {
        profileImageData = imageData
        saveUserData()
        print("📸 Imagem de perfil atualizada")
    }
    
    func addFavoriteMovie(_ movie: Movie) {
        guard canAddFavoriteMovie else {
            print("⚠️ Não é possível adicionar mais filmes - limite de 4 atingido")
            return
        }
        
        let favoriteMovie = FavoriteMovie(from: movie)
        
        if !favoriteMovies.contains(where: { $0.id == favoriteMovie.id }) {
            favoriteMovies.append(favoriteMovie)
            saveUserData()
            print("🎬 Filme '\(favoriteMovie.title)' adicionado aos favoritos")
            
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        } else {
            print("⚠️ Filme '\(favoriteMovie.title)' já está nos favoritos")
        }
    }
    
    func removeFavoriteMovie(_ movie: FavoriteMovie) {
        if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            let removedMovie = favoriteMovies[index]
            favoriteMovies.remove(at: index)
            saveUserData()
            print("🗑️ Filme '\(removedMovie.title)' removido dos favoritos")
            
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
    
    func removeFavoriteMovie(at index: Int) {
        guard index < favoriteMovies.count else { return }
        let removedMovie = favoriteMovies[index]
        favoriteMovies.remove(at: index)
        saveUserData()
        print("🗑️ Filme '\(removedMovie.title)' removido dos favoritos (index \(index))")
    }
    
    func isMovieInFavorites(_ movie: Movie) -> Bool {
        return favoriteMovies.contains { $0.id == movie.id }
    }
    
    private func loadUserData() {
        print("📱 Carregando dados do usuário...")
        
        if let savedName = userDefaults.string(forKey: userNameKey), !savedName.isEmpty {
            userName = savedName
        } else {
            userName = "Nome Padrao"
        }
        
        userEmail = userDefaults.string(forKey: userEmailKey) ?? ""
        
        userPassword = userDefaults.string(forKey: userPasswordKey) ?? ""
        
        profileImageData = userDefaults.data(forKey: profileImageKey)
        
        if let data = userDefaults.data(forKey: favoriteMoviesKey) {
            do {
                favoriteMovies = try JSONDecoder().decode([FavoriteMovie].self, from: data)
                print("✅ \(favoriteMovies.count) filmes favoritos carregados")
            } catch {
                print("❌ Erro ao carregar filmes favoritos: \(error.localizedDescription)")
                favoriteMovies = []
            }
        }
        
        print("👤 Dados carregados - Nome: \(userName), Email: \(userEmail), Filmes: \(favoriteMovies.count)")
    }
    
    private func saveUserData() {
        print("💾 Salvando dados do usuário...")
        
        userDefaults.set(userName, forKey: userNameKey)
        
        userDefaults.set(userEmail, forKey: userEmailKey)
        
        userDefaults.set(userPassword, forKey: userPasswordKey)
        
        if let imageData = profileImageData {
            userDefaults.set(imageData, forKey: profileImageKey)
        } else {
            userDefaults.removeObject(forKey: profileImageKey)
        }
        
        do {
            let data = try JSONEncoder().encode(favoriteMovies)
            userDefaults.set(data, forKey: favoriteMoviesKey)
            print("✅ Dados salvos com sucesso")
        } catch {
            print("❌ Erro ao salvar filmes favoritos: \(error.localizedDescription)")
        }
    }
    
    func resetToDefault() {
        userName = "Mia"
        userEmail = ""
        userPassword = ""
        favoriteMovies = []
        profileImageData = nil
        saveUserData()
        print("🔄 Dados do usuário resetados para padrão")
    }
    
    func clearFavoriteMovies() {
        favoriteMovies.removeAll()
        saveUserData()
        print("🧹 Filmes favoritos limpos")
    }
}
