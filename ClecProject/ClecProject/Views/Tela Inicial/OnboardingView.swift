//
//  OnboardingView.swift
//  ClecProject
//
//  Created by alsy ★ on 02/09/25.
//

import SwiftUI

enum OnboardingPage: Int, CaseIterable {
    case firstPage
    case secondPage
    case thirdPage
    
    // títulos
    var title: String {
        switch self {
        case .firstPage:
            return "Bem-vinde ao Cleck!"
        case .secondPage:
            return "Ei, assistente de direção!"
        case .thirdPage:
            return "Organize sua ordem do dia"
        }
    }
    
    // descrições
    var description: String {
        switch self {
        case .firstPage:
            return "O app que ajuda você a organizar a ordem do dia e manter toda a equipe alinhada nas gravações"
        case .secondPage:
            return "Crie um projeto e compartilhe com sua equipe para centralizar informações e documentos."
        case .thirdPage:
            return "Selecione a data desejada, adicione as cenas e gerencie mudanças em tempo real. Simples e rápido!"
        }
    }
    
    // exibir botão somente na última página
    var hasButton: Bool {
        switch self {
        case .thirdPage:
            return true
        default:
            return false
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @Binding var isUserOldLocal: Bool
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                    getPageView(for: page)
                        .tag(page.rawValue)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .foregroundStyle(Color.backgroundDark)
            .background(Color.backgroundDark)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: currentPage)
            
            // indicador de página
            HStack(spacing: 12) {
                ForEach(0..<OnboardingPage.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.primaryOrange : Color.laranjaPastel)
                        .frame(width: currentPage == index ? 12 : 8,
                               height: currentPage == index ? 12 : 8)
                        .animation(.spring(), value: currentPage)
                }
            }
        }
        .background(Color.backgroundDark)
        .onAppear {
            isAnimating = true
        }
    }
    
    // imagens
    private var firstPageGroup: some View {
        ZStack {
            Image("logoOnboarding")
                .padding()
                .scaledToFit()
                .offset(y: isAnimating ? -120 : 20)
            
            ClaqueteView(isAnimating: $isAnimating)
        }
    }
    
    private var secondPageGroup: some View {
        ZStack {
            Image("botoesOnboarding")
                .padding()
                .scaledToFit()
                .offset(y: isAnimating ? 0 : 20)
            
            Image("personagemOnboarding")
                .scaledToFit()
                .frame(height: 200)
                .offset(x: 25, y: isAnimating ? 85 : 20)
        }
    }
    
    private var thirdPageGroup: some View {
        ZStack {
            Image("duasTelasOnboarding")
                .padding()
                .scaledToFit()
                .offset(y: isAnimating ? 0 : 20)
        }
    }
    
    @ViewBuilder
    private func getPageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 30) {
            // imagens
            ZStack {
                switch page {
                case .firstPage: firstPageGroup
                case .secondPage: secondPageGroup
                case .thirdPage: thirdPageGroup
                }
            }
            
            // textos
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(Color("DesignSystem/OnPrimary"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                
                Text(page.description)
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(Color("DesignSystem/OnPrimary"))
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }
            
            // botão final
            if page.hasButton {
                Button {
                    isUserOldLocal = true
                    UserDefaults.standard.set(true, forKey: "isUserOld")
                } label: {
                    Text("Começar")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color("DesignSystem/OnPrimary"))
                        .tracking(-0.43)
                }
                .padding()
                .background(Color("DesignSystem/Primary"))
                .cornerRadius(12)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.top, 50)
    }
}

#Preview {
    @Previewable @State var isUserOldLocal = false
    OnboardingView(isUserOldLocal: $isUserOldLocal)
}
