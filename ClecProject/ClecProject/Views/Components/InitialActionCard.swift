//
//  InitialActionCard.swift
//  ClecProject
//

import SwiftUI

struct InitialActionCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let imageWidth: CGFloat
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .light ? .white : Color(hex: "#141414"))
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 4)

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("DesignSystem/Primary"))
                            .tracking(-0.45)
                        
                        Text(subtitle)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .tracking(-0.31)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding(.leading, 24)

                HStack {
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageWidth)
                        .offset(x: 30)
                }
            }
            .frame(height: 156)
            .clipped()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
