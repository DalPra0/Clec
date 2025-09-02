//
//  LoginModalView.swift
//  ClecProject
//
//  Created by alsy ★ on 31/08/25.
//

import SwiftUI

struct LoginModalView: View {
    
    @State var toggle = true
 //   @Binding var appState: AppState
    
    @State var email: String = ""
    @State var senha: String = ""
    
    var allFieldsFilled: Bool {
        !email.isEmpty && !senha.isEmpty
    }
    
    
    var body: some View {
        
        VStack(spacing: 50){
            
            VStack(alignment: .leading, spacing: 30){
                Text("Bem-vindo")
                    .font(.largeTitle)
                    .bold()
                
                VStack(spacing: 15){
//                    InputView(extText: $email, isSecure: false, label: "E-mail", placeholder: "Digite seu e-mail ou usuário")
                    
                    VStack(spacing: 12){
                        
//                        InputView(extText: $senha, isSecure: true, label: "Senha", placeholder: "Digite sua senha")
                        
                        
                        HStack{
                            
                            HStack(spacing: 15){
                                
                                Toggle(isOn: $toggle){}
 //                                   .tint(.rosa)
                                    .labelsHidden()
                                
                                Text("Lembrar de mim")
                            }
                            
                            Spacer()
                            
                            Text("Esqueceu sua senha")
                        }
                        .font(.caption)
                    }
                }
            }
            
            VStack(spacing: 20){
                Button{
                    
                    // vai pra home
                    withAnimation{
         //               appState = .onboarding
                    }
                    
                } label: {
                    
                    Text("Entrar")
                        .padding()
                        .foregroundStyle((allFieldsFilled ? .black : .gray))
                        .frame(maxWidth: .infinity)
    //                    .background(allFieldsFilled ? Color.rosa : Color(uiColor: .systemGray3))
                        .clipShape(.buttonBorder)
                }
                .disabled(!allFieldsFilled)
                
                Button{
                    
                    //
                    
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
        }

        .padding(20)
    }
}

#Preview {
//    LoginModalView(appState: .constant(.login))
    LoginModalView()
}
