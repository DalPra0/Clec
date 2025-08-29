//
//  CustomTabBarView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct CustomNavigationBarView<Content: View>: View {
    let returnText: String
    let onReturn: () -> Void
    let backgroundColor: Color?
    
    let content: Content
    
    init(returnText: String, onReturn: @escaping () -> Void, backgroundColor: Color?, @ViewBuilder content: () -> Content) {
        self.returnText = returnText
        self.onReturn = onReturn
        self.backgroundColor = backgroundColor
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {onReturn()}){
                        HStack{
                            Image(systemName: "arrow.left")
                            Text(returnText)
                        }
                        .font(.subheadline)
                        .foregroundStyle(.black)
                        .fontWeight(.light)
                    }
                    Spacer()
                }
                .padding(.horizontal, 36)
                content
            }
        }
        .background(backgroundColor ?? Color.corCustomTabBar)
        
        
    }
    
}

#Preview {
    VStack{
        CustomNavigationBarView(returnText: "Meus Projetos",onReturn: {}, backgroundColor: nil) {
            HStack{
                Text("Ordem do dia")
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                    .padding(.bottom, 16)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .font(.title2)
                Spacer()
            }
        }
        Spacer()
    }
}
