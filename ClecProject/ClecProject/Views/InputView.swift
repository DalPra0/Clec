//
//  InputView.swift
//  ClecProject
//
//  Created by alsy ★ on 31/08/25.
//

import SwiftUI

struct InputView: View {
    
    @State var text  = ""
    @State var isSecure: Bool
    @State var label: String
    @State var placeholder: String
    
    @State var isCompleted: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        
        ZStack{
            
            Color.clear
                .onTapGesture {
                    isFocused = false
                }
            
            VStack{
                
                HStack{
                    
                    Text(label)
                        .foregroundStyle(Color(uiColor: .systemGray))
                        .font(.subheadline)
                        .bold()
                    
                    Spacer()
                }
                
                HStack{
                    
                    if isSecure {
                        
                        SecureField(placeholder, text: $text)
                        
                        Button{
                            // troca o icon
                        } label: {
                            
                            Image(systemName: "eye")
                            
                        }
                        .foregroundStyle(Color(uiColor: .systemGray))
                    }
                    
                    else {
                        
                        TextField(placeholder, text: $text)
                    }
                }
                .padding()
                .overlay{
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((isCompleted ? Color.yellow : Color(UIColor.gray)))
                }
                .focused($isFocused)
                .onChange(of: isFocused){
                    
                    if !isFocused {
                        
                        isCompleted = !text.isEmpty
                    }
                }
            }
        }
    }
}

#Preview {
    InputView(isSecure: true, label: "Senha", placeholder: "Digite sua senha")
}
