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
    @Published var activeProjectId: String?   // 🔥 Novo campo

    private var db = Firestore.firestore()
    private var userListener: ListenerRegistration?
    
    var canAddFavoriteMovie: Bool {
        return favoriteMovies.count < 4
    }
    
    var hasAllFavoriteSlots: Bool {
        return favoriteMovies.count >= 4
    }
    
    init() {
        _ = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            if let user = user {
                self.listenForUserData(userId: user.uid)
            } else {
                self.userListener?.remove()
                self.resetToDefaultLocal()
            }
        }
        
        // Listen for profile creation notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCreateUserProfile(_:)),
            name: Notification.Name("CreateUserProfile"),
            object: nil
        )
    }
    
    deinit {
        userListener?.remove()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleCreateUserProfile(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let name = userInfo["name"] as? String else { return }
        
        print("🎆 Creating user profile for: \(name)")
        setupInitialProfile(name: name)
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
                self.activeProjectId = userProfile.activeProjectId   // 🔥 carrega do Firestore
            } else if !document.exists {
                self.userName = "Usuário"
                self.userEmail = Auth.auth().currentUser?.email ?? ""
                self.activeProjectId = nil
                
                print("⚠️ User profile not found in Firestore. Waiting for profile setup...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if self.userName == "Usuário" {
                        print("🔄 Fallback: Creating profile with default name")
                        self.saveUserData()
                    }
                }
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
            favoriteMovies: self.favoriteMovies,
            activeProjectId: self.activeProjectId   // 🔥 salva também
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
    
    func setupInitialProfile(name: String) {
        userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        userEmail = Auth.auth().currentUser?.email ?? ""
        favoriteMovies = []
        activeProjectId = nil   // 🔥 nenhum projeto ativo ao criar
        saveUserData()
        print("🎆 Perfil inicial criado para: \(userName)")
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
        userName = "Usuário"
        userEmail = ""
        userPassword = ""
        favoriteMovies = []
        profileImageData = nil
        activeProjectId = nil   // 🔥 reseta também
        saveUserData()
        print("🔄 Dados do usuário resetados para padrão")
    }
    
    private func resetToDefaultLocal() {
        self.userName = "Nome Padrão"
        self.userEmail = ""
        self.userPassword = ""
        self.favoriteMovies = []
        self.profileImageData = nil
        self.activeProjectId = nil
    }
    
    func clearFavoriteMovies() {
        favoriteMovies.removeAll()
        saveUserData()
        print("🧹 Filmes favoritos limpos")
    }
    
    func updateActiveProject(_ projectId: String?) {
        self.activeProjectId = projectId
        saveUserData()
    }

}

fileprivate struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String?
    var userName: String
    var userEmail: String
    var favoriteMovies: [FavoriteMovie]
    var activeProjectId: String?   // 🔥 novo campo persistido
}
