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
            return "Frase1"
        case .fraseDois:
            return "Frase2"
        case .fraseTres:
            return "Frase3"
        }
    }
    
    var description: String{
        switch self {
        case .fraseUm:
            return "Frase1"
        case .fraseDois:
            return "Frase2"
        case .fraseTres:
            return "Frase3"
        }
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var deliveryOffset = false
    @State private var trackingProgress: CGFloat = 0.0
    
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
            }
        }
        
    }
    
}

#Preview {
    OnboardingView()
}
