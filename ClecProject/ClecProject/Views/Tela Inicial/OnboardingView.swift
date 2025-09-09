//
//  OnboardingView.swift
//  ClecProject
//
//  Created by alsy ★ on 02/09/25.
//

import SwiftUI

enum OnboardingPage: Int, CaseIterable {
    case fraseUm
    case fraseDois
    case fraseTres
    
    var title: String{
        switch self {
        case .fraseUm:
            return "Bem-vinde ao Cleck!"
        case .fraseDois:
            return "Ei, assistente de direção!"
        case .fraseTres:
            return "Organize sua ordem do dia"
        }
    }
    
    var description: String{
        switch self {
        case .fraseUm:
            return "O app que ajuda você a organizar a ordem do dia e manter toda a equipe alinhada nas gravações"
        case .fraseDois:
            return "Crie um projeto e compartilhe com sua equipe para centralizar informações e documentos."
        case .fraseTres:
            return "Selecione a data desejada, adicione as cenas e gerencie mudanças em tempo real. Simples e rápido!"
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var fraseUm = false
    @State private var fraseDois: CGFloat = 0.0
    
    var body: some View {
        VStack{
            TabView(selection: $currentPage) {
                ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                    getPageView(for: page)
                        .tag(page.rawValue)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: currentPage)
            
            //indicador d pagina
            HStack(spacing:12) {
                ForEach(0..<OnboardingPage.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue :
                            Color.gray.opacity(0.5))
                        .frame(width: currentPage == index ? 12 : 8, height:
                            currentPage == index ? 12: 8)
                        .animation(.spring(), value: currentPage)
                }
            }
        }
        .onAppear() {
            isAnimating = true
        }
    }
    
    @ViewBuilder
    private func getPageView(for page: OnboardingPage) -> some View {
        VStack(spacing:30) {
            
            //texto aki
            VStack(spacing:20) {
                Text(page.title)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value:
                        isAnimating)
                
                Text(page.description)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value:
                        isAnimating)
            
            }
        }
        
    }
    
}

#Preview {
    OnboardingView()
}
