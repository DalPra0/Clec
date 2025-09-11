//
//  TeamMembersView.swift
//  ClecProject
//
//  Team members management view
//  Created by Lucas Dal Pra Brascher on 10/09/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct TeamMembersView: View {
    let project: ProjectModel
    @EnvironmentObject var projectManager: ProjectManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var memberProfiles: [MemberProfile] = []
    @State private var isLoading = true
    @State private var showingInviteView = false
    @State private var showingRemoveMemberAlert = false
    @State private var memberToRemove: MemberProfile?
    
    private var isProjectOwner: Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        return project.ownerId == userId
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                
                if isLoading {
                    loadingView
                } else {
                    membersList
                }
                
                Spacer()
            }
            .background(Color("BackgroundDark"))
            .navigationBarHidden(true)
        }
        .onAppear {
            loadTeamMembers()
        }
        .sheet(isPresented: $showingInviteView) {
            ShareProjectView(project: project)
        }
        .alert("Remover Membro", isPresented: $showingRemoveMemberAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Remover", role: .destructive) {
                if let member = memberToRemove {
                    removeMember(member)
                }
            }
        } message: {
            Text("Tem certeza que deseja remover \\(memberToRemove?.name ?? \"este membro\") da equipe?")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color("CardBackground"))
                    )
            }
            
            Spacer()
            
            Text("Equipe")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            if isProjectOwner {
                Button(action: { showingInviteView = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Color("PrimaryOrange"))
                        )
                }
            } else {
                Color.clear
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color("PrimaryOrange")))
                .scaleEffect(1.2)
            
            Text("Carregando membros...")
                .font(.system(size: 16))
                .foregroundColor(Color("TextSecondary"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Members List
    private var membersList: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Project Info
                projectInfoSection
                
                // Members Section
                membersSection
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var projectInfoSection: some View {
        VStack(spacing: 12) {
            Text(project.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Dir. \\(project.director)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("TextSecondary"))
            
            Text("Código: \\(project.code)")
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(Color("PrimaryOrange"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("CardBackground"))
                )
        }
        .padding(.vertical, 20)
    }
    
    private var membersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Membros da Equipe")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\\(memberProfiles.count) membro(s)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            VStack(spacing: 12) {
                ForEach(memberProfiles) { member in
                    MemberRowView(
                        member: member,
                        isOwner: member.userId == project.ownerId,
                        canRemove: isProjectOwner && member.userId != project.ownerId,
                        onRemove: {
                            memberToRemove = member
                            showingRemoveMemberAlert = true
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Actions
    private func loadTeamMembers() {
        isLoading = true
        let db = Firestore.firestore()
        
        // Get user profiles for all members
        let memberIds = project.members
        var loadedProfiles: [MemberProfile] = []
        let group = DispatchGroup()
        
        for memberId in memberIds {
            group.enter()
            
            db.collection("users").document(memberId).getDocument { document, error in
                defer { group.leave() }
                
                if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    let profile = MemberProfile(
                        userId: memberId,
                        name: data["userName"] as? String ?? "Usuário",
                        email: data["userEmail"] as? String ?? ""
                    )
                    loadedProfiles.append(profile)
                } else {
                    // User not found in Firestore, use ID as fallback
                    let profile = MemberProfile(
                        userId: memberId,
                        name: "Usuário",
                        email: ""
                    )
                    loadedProfiles.append(profile)
                }
            }
        }
        
        group.notify(queue: .main) {
            // Sort: owner first, then alphabetically
            self.memberProfiles = loadedProfiles.sorted { member1, member2 in
                if member1.userId == self.project.ownerId { return true }
                if member2.userId == self.project.ownerId { return false }
                return member1.name < member2.name
            }
            self.isLoading = false
        }
    }
    
    private func removeMember(_ member: MemberProfile) {
        guard let projectId = project.id else { return }
        
        let db = Firestore.firestore()
        db.collection("projects").document(projectId).updateData([
            "members": FieldValue.arrayRemove([member.userId])
        ]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error removing member: \\(error.localizedDescription)")
                } else {
                    print("✅ Member removed successfully")
                    
                    // Remove from local list
                    self.memberProfiles.removeAll { $0.userId == member.userId }
                    
                    // Haptic feedback
                    let notificationFeedback = UINotificationFeedbackGenerator()
                    notificationFeedback.notificationOccurred(.success)
                }
            }
        }
    }
}

// MARK: - Member Profile Model
struct MemberProfile: Identifiable {
    let id = UUID()
    let userId: String
    let name: String
    let email: String
}

// MARK: - Member Row Component
struct MemberRowView: View {
    let member: MemberProfile
    let isOwner: Bool
    let canRemove: Bool
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: isOwner ? 
                            [Color("PrimaryOrange"), Color("PrimaryOrange").opacity(0.7)] :
                            [Color.blue, Color.blue.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 50, height: 50)
                .overlay(
                    Text(member.name.prefix(1).uppercased())
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                )
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(member.name)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    if isOwner {
                        Text("OWNER")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color("PrimaryOrange"))
                            )
                    }
                }
                
                if !member.email.isEmpty {
                    Text(member.email)
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
            }
            
            Spacer()
            
            // Remove button (only for non-owners if current user is owner)
            if canRemove {
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.red.opacity(0.15))
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
        )
    }
}

#Preview {
    TeamMembersView(project: ProjectModel(
        code: "AB12",
        director: "Christopher Nolan",
        name: "Interstellar",
        deadline: Date(),
        callSheet: [],
        ownerId: "user123",
        members: ["user123", "user456"]
    ))
    .background(Color("BackgroundDark"))
    .environmentObject(ProjectManager())
}
