//
//  HelpView.swift
//  ClecProject
//
//  Help and support view with FAQ
//  Created by Lucas Dal Pra Brascher on 10/09/25.
//

import SwiftUI
import MessageUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingContactForm = false
    @State private var expandedFAQ: Int? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    quickActionsSection
                    
                    faqSection
                    
                    contactSection
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .background(Color("BackgroundDark"))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingContactForm) {
            ContactFormView()
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
            
            Text("Ajuda e Suporte")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Ações Rápidas")
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickActionCard(
                    icon: "questionmark.circle.fill",
                    title: "FAQ",
                    subtitle: "Perguntas frequentes",
                    action: { scrollToFAQ() }
                )
                
                QuickActionCard(
                    icon: "envelope.fill",
                    title: "Contato",
                    subtitle: "Fale conosco",
                    action: { showingContactForm = true }
                )
                
                QuickActionCard(
                    icon: "video.fill",
                    title: "Tutorial",
                    subtitle: "Como usar o app",
                    action: { openTutorial() }
                )
                
                QuickActionCard(
                    icon: "book.fill",
                    title: "Guia",
                    subtitle: "Manual completo",
                    action: { openUserGuide() }
                )
            }
        }
    }
    
    // MARK: - FAQ Section
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Perguntas Frequentes")
            
            VStack(spacing: 12) {
                ForEach(Array(faqItems.enumerated()), id: \.offset) { index, faq in
                    FAQItemView(
                        question: faq.question,
                        answer: faq.answer,
                        isExpanded: expandedFAQ == index,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                expandedFAQ = expandedFAQ == index ? nil : index
                            }
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Contact Section
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Ainda Precisa de Ajuda?")
            
            VStack(spacing: 16) {
                ContactOptionRow(
                    icon: "envelope.fill",
                    title: "E-mail de Suporte",
                    subtitle: "suporte@clecqui.com",
                    action: { sendEmail() }
                )
                
                ContactOptionRow(
                    icon: "message.fill",
                    title: "WhatsApp",
                    subtitle: "Chat direto conosco",
                    action: { openWhatsApp() }
                )
                
                ContactOptionRow(
                    icon: "globe",
                    title: "Site Oficial",
                    subtitle: "www.clecqui.com",
                    action: { openWebsite() }
                )
            }
        }
    }
    
    // MARK: - Helper Views
    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
    }
    
    // MARK: - Actions
    private func scrollToFAQ() {
        // TODO: Implement scroll to FAQ section
        print("📋 Scrolling to FAQ")
    }
    
    private func openTutorial() {
        // TODO: Open tutorial video or modal
        print("📹 Opening tutorial")
    }
    
    private func openUserGuide() {
        // TODO: Open user guide PDF or web page
        print("📖 Opening user guide")
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            // TODO: Implement mail composer
            print("📧 Opening mail composer")
        } else {
            // Open mail app with pre-filled email
            if let emailURL = URL(string: "mailto:suporte@clecqui.com?subject=Suporte CLÉQUI!") {
                UIApplication.shared.open(emailURL)
            }
        }
    }
    
    private func openWhatsApp() {
        // TODO: Open WhatsApp with pre-filled message
        print("💬 Opening WhatsApp")
    }
    
    private func openWebsite() {
        if let websiteURL = URL(string: "https://www.clecqui.com") {
            UIApplication.shared.open(websiteURL)
        }
    }
}

// MARK: - FAQ Data
struct FAQItem {
    let question: String
    let answer: String
}

extension HelpView {
    private var faqItems: [FAQItem] {
        [
            FAQItem(
                question: "Como criar um novo projeto?",
                answer: "Na tela inicial, toque em 'Criar Projeto'. Preencha as informações básicas como nome do projeto, diretor e descrição. Um código único será gerado automaticamente para compartilhar com sua equipe."
            ),
            FAQItem(
                question: "Como entrar em um projeto existente?",
                answer: "Na tela inicial, toque em 'Entrar no Projeto' e digite o código de 4 caracteres fornecido pelo criador do projeto. O código é case-insensitive."
            ),
            FAQItem(
                question: "Como adicionar uma nova cena à ordem do dia?",
                answer: "No Dashboard, selecione a data desejada no calendário e toque no botão '+' laranja. Preencha as informações da cena como descrição, localização e horário."
            ),
            FAQItem(
                question: "Como compartilhar o projeto com a equipe?",
                answer: "Nas Configurações do projeto, toque em 'Compartilhar Projeto'. Você pode copiar o código ou usar o botão de compartilhar para enviar via WhatsApp, email, etc."
            ),
            FAQItem(
                question: "Como editar as informações do projeto?",
                answer: "Apenas o criador do projeto (owner) pode editar as configurações. Nas Configurações, toque em 'Configurações do Projeto' para alterar nome, diretor, descrição e deadline."
            ),
            FAQItem(
                question: "Como sair de um projeto?",
                answer: "Nas Configurações, role até a seção 'Projeto' e toque em 'Sair do Projeto'. Confirme a ação. O criador do projeto não pode sair, apenas excluir o projeto inteiro."
            ),
            FAQItem(
                question: "Os dados ficam salvos na nuvem?",
                answer: "Sim! Todos os dados são automaticamente sincronizados via Firebase. Você pode acessar seus projetos de qualquer dispositivo fazendo login com a mesma conta."
            ),
            FAQItem(
                question: "Como ativar as notificações?",
                answer: "Nas Configurações do App, ative 'Notificações Push'. Você pode personalizar quais tipos de alertas deseja receber: lembretes diários ou atualizações do projeto."
            )
        ]
    }
}

// MARK: - Quick Action Card
struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(Color("PrimaryOrange"))
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color("TextSecondary"))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("CardBackground"))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - FAQ Item View
struct FAQItemView: View {
    let question: String
    let answer: String
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    Text(question)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 14))
                    .foregroundColor(Color("TextSecondary"))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .transition(.opacity.combined(with: .scale(scale: 1, anchor: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("CardBackground"))
        )
    }
}

// MARK: - Contact Option Row
struct ContactOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color("PrimaryOrange"))
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("PrimaryOrange").opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color("TextSecondary"))
                }
                
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

// MARK: - Contact Form View
struct ContactFormView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Entre em Contato")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                // TODO: Implement contact form
                Text("Formulário de contato em desenvolvimento")
                    .foregroundColor(.gray)
                    .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fechar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HelpView()
        .background(Color("BackgroundDark"))
}
