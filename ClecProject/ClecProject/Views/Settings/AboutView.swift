//
//  AboutView.swift
//  ClecProject
//
//  About app and credits view
//  Created by Lucas Dal Pra Brascher on 10/09/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    
                    appInfoSection
                    
                    creditsSection
                    
                    legalSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(Color("BackgroundDark"))
            .navigationBarHidden(true)
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
            
            Text("Sobre o App")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    // MARK: - App Info Section
    private var appInfoSection: some View {
        VStack(spacing: 24) {
            // App Icon
            Image(systemName: "film")
                .font(.system(size: 80))
                .foregroundColor(Color("PrimaryOrange"))
                .frame(width: 120, height: 120)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color("CardBackground"))
                )
            
            VStack(spacing: 8) {
                Text("CLÉQUI!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Versão 1.0.0")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("TextSecondary"))
                
                Text("Build 2025.09.10")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Text("O app que revoluciona a organização de produções audiovisuais, centralizando cronogramas, ordem do dia e comunicação da equipe.")
                .font(.system(size: 16))
                .foregroundColor(Color("TextSecondary"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Credits Section
    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Créditos")
            
            VStack(spacing: 16) {
                CreditRow(
                    title: "Desenvolvimento",
                    people: ["Lucas Dal Pra Brascher", "Giovanni Galarda Strasser"]
                )
                
                CreditRow(
                    title: "Design UI/UX",
                    people: ["Equipe de Design CLÉQUI!"]
                )
                
                CreditRow(
                    title: "Consultoria Cinema",
                    people: ["Assistentes de Direção Profissionais"]
                )
                
                CreditRow(
                    title: "Agradecimentos Especiais",
                    people: ["Apple Developer Program", "Firebase Team", "Comunidade iOS"]
                )
            }
        }
    }
    
    // MARK: - Legal Section
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Legal")
            
            VStack(spacing: 16) {
                LegalRow(
                    title: "Termos de Uso",
                    action: { openTermsOfUse() }
                )
                
                LegalRow(
                    title: "Política de Privacidade",
                    action: { openPrivacyPolicy() }
                )
                
                LegalRow(
                    title: "Licenças de Terceiros",
                    action: { openThirdPartyLicenses() }
                )
            }
            
            // Copyright
            VStack(spacing: 8) {
                Text("© 2025 CLÉQUI! Todos os direitos reservados.")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
                
                Text("Feito com ❤️ para a comunidade audiovisual")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
    }
    
    // MARK: - Actions
    private func openTermsOfUse() {
        // TODO: Open terms of use URL or modal
        print("📄 Opening Terms of Use")
    }
    
    private func openPrivacyPolicy() {
        // TODO: Open privacy policy URL or modal
        print("🔒 Opening Privacy Policy")
    }
    
    private func openThirdPartyLicenses() {
        // TODO: Open third party licenses modal
        print("📚 Opening Third Party Licenses")
    }
}

// MARK: - Credit Row Component
struct CreditRow: View {
    let title: String
    let people: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(people, id: \.self) { person in
                    Text(person)
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
        )
    }
}

// MARK: - Legal Row Component
struct LegalRow: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("CardBackground"))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AboutView()
        .background(Color("BackgroundDark"))
}
