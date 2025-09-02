//
//  SignInView.swift
//  ClecProject
//
//  Created by alsy ★ on 31/08/25.
//

import SwiftUI

struct SignInView: View {
    
//    @Binding var appState: AppState
    
    var body: some View {
        
        VStack(spacing: 20){
            
            // header + butao
            
            VStack(spacing: 30){
            
                // header
                
                VStack(spacing: 25){
                    
                    Image("")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 124)
                    
                    (
                        Text("")
                        
                        + Text("")
                            .foregroundStyle(.yellow)
                            .bold()
                        
                        + Text("")
                    )
                        .font(.title3)
                        .frame(width: 335)
                        .multilineTextAlignment(.center)
                    
                }
                .padding(.top)
                
                Button{
                    
                } label: {
                    
                    HStack{
                        
                        Image(systemName: "apple.logo")
                        Text("Continuar com Apple")
                    }
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .clipShape(.buttonBorder)
                }
            }
            
            //text fields
            
            VStack{
                
                // divider
                
                HStack{
                    
                    VStack{Divider()}
                    
                    Text("ou")
                     
                    VStack{Divider()}
                }
                .foregroundStyle(Color(uiColor: .systemGray))
                .padding(.horizontal)
                
                // text fields + butao
                
                VStack(spacing: 35){
                    
                    // text fields
                    
                    VStack(spacing: 15){
                        
                        
                        InputView(isSecure: false, label: "Usuário", placeholder: "Digite seu nome de usuário")
                        
                        InputView(isSecure: false, label: "E-mail", placeholder: "Digite seu e-mail")
                        
                        InputView(isSecure: true, label: "Senha", placeholder: "Digite sua senha")
                        
                        InputView(isSecure: true, label: "Confirmação", placeholder: "Confirme sua senha")
                    }
                    
                    Button{
                        
                        // vai pra home
                        withAnimation{
//                            appState = .navigation
                            
                        }
                    } label: {
                        
                        Text("Criar conta")
                        .font(.title3)
                        .foregroundStyle(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: .systemGray3))
                        .clipShape(.buttonBorder)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
//    SignInView(appState: .constant(.login))
SignInView()
}
