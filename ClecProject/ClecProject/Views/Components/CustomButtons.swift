//
//  CreateNewButton.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 01/09/25.
//

import SwiftUI

struct CustomButton: View{
    let title: String
    var body: some View{
        Text(title)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(Color.purple)
            .cornerRadius(16)
            .padding(.horizontal, 20)
    }
}

struct CustomNavigationButton<Destination: View>: View {
    let title: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            CustomButton(title:title)
        }
    }
}


struct CustomActionButton: View {
    let title: String
    let onTap: ()->()

    var body: some View {
        Button(action:{onTap()}) {
            CustomButton(title:title)
        }
    }
}


// MARK: - Preview

#Preview {
}
