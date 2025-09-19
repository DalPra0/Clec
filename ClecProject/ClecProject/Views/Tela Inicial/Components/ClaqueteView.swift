//
//  ClaqueteView.swift
//  ClecProject
//
//  Created by alsy ★ on 16/09/25.
//

import SwiftUI

struct ClaqueteView: View {
    
    @Binding var isAnimating : Bool
    private static let delayBetweenImages: CGFloat = 0.25
    @State private var currentImageIndex = 0
    private let animationTimerPublisher = Timer.publish(
      every: delayBetweenImages,
      on: .main,
      in: .default).autoconnect()
    
    var body: some View {
        Group {
            if currentImageIndex == 1 || currentImageIndex == 3 || currentImageIndex == 5 {
                Image("claqueteOnboarding")
                    .resizable()
                    .frame(height: 200)
                    .offset(x: -20, y: isAnimating ? 40 : 20)
            }
            
            else {
                Image("claqueteFechadaOnboarding")
                    .resizable()
                    .frame(height: 200)
                    .offset(x: -20, y: isAnimating ? 49.8 : 20)
            }
        }
        .onReceive(animationTimerPublisher) { _ in
          updateCurrentImage()
        }
    }
    
    private func updateCurrentImage() {
        if currentImageIndex >= 5 { return }
        currentImageIndex += 1
    }
}

#Preview {
    @Previewable @State var isAnimating = false
    ClaqueteView(isAnimating: $isAnimating)
}
