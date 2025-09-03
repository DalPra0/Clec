//
//  AuthService.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 03/09/25.
//

import Foundation
import FirebaseAuth
import Combine

class AuthService: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.userSession = user
        }
    }
    
    deinit {
        if let handle = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    
    @MainActor
    func signIn(withEmail email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            print("✅ User signed in successfully: \(userSession?.email ?? "No email")")
        } catch {
            print("❌ Error signing in: \(error.localizedDescription)")
            self.errorMessage = mapFirebaseError(error)
        }
        isLoading = false
    }
    
    @MainActor
    func signUp(withEmail email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            print("✅ User created and signed in successfully: \(userSession?.email ?? "No email")")
        } catch {
            print("❌ Error signing up: \(error.localizedDescription)")
            self.errorMessage = mapFirebaseError(error)
        }
        isLoading = false
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("✅ User signed out successfully.")
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
            self.errorMessage = "Failed to sign out. Please try again."
        }
    }
    
    private func mapFirebaseError(_ error: Error) -> String {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.wrongPassword.rawValue:
            return "The password you entered is incorrect. Please try again."
        case AuthErrorCode.invalidEmail.rawValue:
            return "The email address is not valid. Please check and try again."
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found with this email. Please sign up first."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email address is already in use by another account."
        case AuthErrorCode.weakPassword.rawValue:
            return "The password is too weak. It must be at least 6 characters long."
        case AuthErrorCode.networkError.rawValue:
            return "A network error occurred. Please check your connection."
        default:
            return "An unknown error occurred. Please try again."
        }
    }
}
