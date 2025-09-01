//
//  CustomReturn.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 01/09/25.
//

import SwiftUI

struct CustomReturn: View {
    let text: String
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(text)
                Spacer()
            }
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .font(.title2)
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
        }    }
}

#Preview {
    CustomReturn(text: "Voltar")
}
