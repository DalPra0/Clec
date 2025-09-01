//
//  ProjectViewButton.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct ProjectViewButton: View {
    let icon: String
    let title: String
    let onClick: () -> Void
    var body: some View {
        Button(action: {}) {
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.projectViewButtonBackground)
                HStack{
                    Image(systemName: icon)
                    Text(title)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    ProjectViewButton(icon: "tray.fill", title: "title", onClick: {})
}
