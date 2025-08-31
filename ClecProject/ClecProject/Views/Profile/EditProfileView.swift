//
//  EditProfileView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingImagePicker = false
    @State private var showingMovieSearch = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    // Validation states
    @State private var isFormValid = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Profile Image Section
                    profileImageSection
                    
                    // Form Fields
                    formFieldsSection
                    
                    // Favorite Movies Section
                    favoriteMoviesSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.primary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Pronto") {
                        saveProfile()
                    }
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                }
            }
            .sheet(isPresented: $showingMovieSearch) {
                MovieSearchView()
                    .environmentObject(userManager)
            }
            .photosPicker(
                isPresented: $showingImagePicker,
                selection: $selectedPhotoItem,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: selectedPhotoItem) { _, newItem in
                loadImage(from: newItem)
            }
            .onAppear {
                loadCurrentData()
                validateForm()
            }
            .onChange(of: fullName) { _, _ in validateForm() }
            .onChange(of: email) { _, _ in validateForm() }
            .onChange(of: password) { _, _ in validateForm() }
        }
    }
    
    // MARK: - Profile Image Section
    private var profileImageSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingImagePicker = true
            }) {
                ZStack {
                    if let imageData = userManager.profileImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        // Default sheep image or gradient
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.6)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button("Change profile picture") {
                showingImagePicker = true
            }
            .font(.system(size: 16))
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Form Fields Section
    private var formFieldsSection: some View {
        VStack(spacing: 20) {
            // Full Name Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Nome completo")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Nome do usuário", text: $fullName)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .autocorrectionDisabled()
            }
            
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                Text("E-mail")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                
                TextField("Nome do usuário", text: $email)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            
            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                Text("Senha")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                
                SecureField("Nome do usuário", text: $password)
                    .font(.system(size: 16))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
            }
        }
    }
    
    // MARK: - Favorite Movies Section
    private var favoriteMoviesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Filmes Favoritos")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(userManager.favoriteMovies.count)/4")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }
            
            // Movie Grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    movieSlot(at: index)
                }
            }
        }
    }
    
    // MARK: - Movie Slot
    @ViewBuilder
    private func movieSlot(at index: Int) -> some View {
        let movie = index < userManager.favoriteMovies.count ? userManager.favoriteMovies[index] : nil
        
        Button(action: {
            if movie != nil {
                // Show options to remove or replace
                showRemoveMovieAlert(at: index)
            } else {
                // Add new movie
                showingMovieSearch = true
            }
        }) {
            MoviePosterView(
                movie: movie,
                size: CGSize(width: 70, height: 105),
                cornerRadius: 8
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Actions
    private func loadCurrentData() {
        fullName = userManager.userName
        email = userManager.userEmail
        password = userManager.userPassword
    }
    
    private func validateForm() {
        let trimmedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        isFormValid = !trimmedName.isEmpty
    }
    
    private func saveProfile() {
        guard isFormValid else { return }
        
        userManager.updateUserName(fullName.trimmingCharacters(in: .whitespacesAndNewlines))
        userManager.updateUserEmail(email.trimmingCharacters(in: .whitespacesAndNewlines))
        userManager.updateUserPassword(password)
        
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func loadImage(from photoItem: PhotosPickerItem?) {
        guard let photoItem = photoItem else { return }
        
        Task {
            if let data = try? await photoItem.loadTransferable(type: Data.self) {
                await MainActor.run {
                    userManager.updateProfileImage(data)
                }
            }
        }
    }
    
    private func showRemoveMovieAlert(at index: Int) {
        guard index < userManager.favoriteMovies.count else { return }
        
        let movie = userManager.favoriteMovies[index]
        
        let alert = UIAlertController(
            title: movie.title,
            message: "O que você gostaria de fazer?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Remover", style: .destructive) { _ in
            userManager.removeFavoriteMovie(at: index)
        })
        
        alert.addAction(UIAlertAction(title: "Substituir", style: .default) { _ in
            userManager.removeFavoriteMovie(at: index)
            showingMovieSearch = true
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        // Present alert
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(alert, animated: true)
        }
    }
}

// MARK: - Preview
#Preview {
    EditProfileView()
        .environmentObject(UserManager())
}
