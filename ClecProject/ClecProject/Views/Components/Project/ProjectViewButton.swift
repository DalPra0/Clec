//
//  ProjectViewButton.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct ProjectViewButton: View {
    let icon: String?
    let title: String
    let onClick: () -> Void
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(Color.projectViewButtonBackground)
            HStack{
                if(icon != nil){
                    Image(systemName: (icon != nil) ? icon! : "")
                }
                Text(title)
            }
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    ProjectViewButton(icon: "tray.fill", title: "title", onClick: {})
}
