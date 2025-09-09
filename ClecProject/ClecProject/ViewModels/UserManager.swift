//
//  UserManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class UserManager: ObservableObject {
    @Published var userName: String = "Nome padrão"
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var favoriteMovies: [FavoriteMovie] = []
    @Published var profileImageData: Data?
    
    private var db = Firestore.firestore()
    private var userListener: ListenerRegistration?
    
    var canAddFavoriteMovie: Bool {
        return favoriteMovies.count < 4
    }
    
    var hasAllFavoriteSlots: Bool {
        return favoriteMovies.count >= 4
    }
    
    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if let user = user {
                self.listenForUserData(userId: user.uid)
            } else {
                self.userListener?.remove()
                self.resetToDefaultLocal()
            }
        }
    }
    
    deinit {
        userListener?.remove()
    }
    
    func listenForUserData(userId: String) {
        userListener?.remove()
        
        let docRef = db.collection("users").document(userId)
        
        userListener = docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let userProfile = try? document.data(as: UserProfile.self) {
                self.userName = userProfile.userName
                self.userEmail = userProfile.userEmail
                self.favoriteMovies = userProfile.favoriteMovies
            } else if !document.exists {
                self.userName = "Mia"
                self.userEmail = Auth.auth().currentUser?.email ?? ""
                self.saveUserData()
            }
        }
    }
    
    private func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userProfile = UserProfile(
            id: userId,
            userName: self.userName,
            userEmail: self.userEmail,
            favoriteMovies: self.favoriteMovies
        )
        
        do {
            try db.collection("users").document(userId).setData(from: userProfile, merge: true)
        } catch {
            print("Error saving user data to Firestore: \(error.localizedDescription)")
        }
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
        print("🔒 Senha atualizada")
    }
    
    func updateProfileImage(_ imageData: Data?) {
        profileImageData = imageData
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
    
    func resetToDefault() {
        userName = "Mia"
        userEmail = ""
        userPassword = ""
        favoriteMovies = []
        profileImageData = nil
        saveUserData()
        print("🔄 Dados do usuário resetados para padrão")
    }
    
    private func resetToDefaultLocal() {
        self.userName = "Nome Padrão"
        self.userEmail = ""
        self.userPassword = ""
        self.favoriteMovies = []
        self.profileImageData = nil
    }
    
    func clearFavoriteMovies() {
        favoriteMovies.removeAll()
        saveUserData()
        print("🧹 Filmes favoritos limpos")
    }
}

fileprivate struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String?
    var userName: String
    var userEmail: String
    var favoriteMovies: [FavoriteMovie]
}
