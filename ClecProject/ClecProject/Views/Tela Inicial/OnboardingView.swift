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
    
    //titulos
    var title: String{
        switch self {
        case .firstPage:
            return "Bem-vinde ao Cleck!"
        case .secondPage:
            return "Ei, assistente de direção!"
        case .thirdPage:
            return "Organize sua ordem do dia"
        }
    }
    
    //descriçoes
    var description: String{
        switch self {
        case .firstPage:
            return "O app que ajuda você a organizar a ordem do dia e manter toda a equipe alinhada nas gravações"
        case .secondPage:
            return "Crie um projeto e compartilhe com sua equipe para centralizar informações e documentos."
        case .thirdPage:
            return "Selecione a data desejada, adicione as cenas e gerencie mudanças em tempo real. Simples e rápido!"
        }
    }
    
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var firstPage = false
    @State private var secondPage: CGFloat = 0.0
    @Binding var isUserOldLocal: Bool
    
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
                        .fill(currentPage == index ? Color.laranjaPastel :
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
    
    //imagens
    private var firstPageGroup: some View {
        ZStack {
            Image("logoOnboarding")
                .padding()
                .scaledToFit()
                .offset(y: isAnimating ? -120 : 20)
            
            Image("claqueteOnboarding")
                .resizable()
                .frame(height: 200)
                .offset(x: -20, y: isAnimating ? 40 : 20)
        }
    }
    
    private var secondPageGroup: some View {
        ZStack {
            Image("logoOnboarding")
                .padding()
                .scaledToFit()
                .offset(y: isAnimating ? 0 : 20)
            
//            Image("claqueteOnboarding")
//                .padding()
//                .scaledToFit()
//                .frame(height: 100)
//                .offset(y: isAnimating ? 0 : 20)
        }
    }
    
    private var thirdPageGroup: some View {
        ZStack {
            Image("logoOnboarding")
                .padding()
                .scaledToFit()
                .offset(y: isAnimating ? 0 : 20)
            
            VStack{
                Spacer()
                Button("ai ta bom sai"){
                    isUserOldLocal = true
                    print("sai aaaa de mim kkk")
                    UserDefaults.standard.set(true, forKey: "isUserOld")
                }
            }
            
//            Image("claqueteOnboarding")
//                .padding()
//                .scaledToFit()
//                .frame(height: 100)
//                .offset(y: isAnimating ? 0 : 20)
        }
    }
    
    @ViewBuilder
    private func getPageView(for page: OnboardingPage) -> some View {
        VStack(spacing:30) {
            
            //config imagens
            ZStack {
                switch page {
                case .firstPage:
                    firstPageGroup
                case .secondPage:
                    secondPageGroup
                case .thirdPage:
                    thirdPageGroup
                }
            }
            
            //config textos
            VStack(spacing:20) {
                Text(page.title)
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value:
                        isAnimating)
                    .rotationEffect(Angle(degrees: 20))
                
                Text(page.description)
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value:
                        isAnimating)
            
            }
        }
        .padding(.top,50)
    }
    
}

#Preview {
    @Previewable @State var isUserOldLocal = false
    OnboardingView(isUserOldLocal: $isUserOldLocal)
}
