//
//  LoginView.swift
//  ClecProject
//
//  Created by alsy ★ on 28/08/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var showModal = false
   // @Binding var appState: AppState
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing: 170){
                
                VStack(spacing: 30){
                    
                    Image("logoClaro")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230)
                    
                    Text("Só duvida quem não viu todos.")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
                .offset(y: showModal ? -150 : 0)
                .animation(.easeInOut, value: showModal)
                
                VStack (spacing: 30){
                    
                    Button{
                        
                       withAnimation{
                           showModal = true
                       }
                        
                    } label: {
                        
                        Text("Fazer login")
                            .padding()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .clipShape(.buttonBorder)
                    }
                    
                
                        
                    NavigationLink{
                        
  //                      SignInView(appState: $appState)
                        
                    }label: {
                        
                        Text("Criar conta")
                            .padding()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
            //                .background(.rosa)
                            .clipShape(.buttonBorder)
                    }
                }
                .padding(.horizontal, 20)
                
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
       //     .background(.azulEscuro)
            .sheet(isPresented: $showModal){
                
        //        LoginModalView(appState: $appState)
                LoginModalView()
                    .presentationDetents([
                        .height(516)
                    ])
            }
        }
    }
}

#Preview {
 //   LoginView(appState: .constant(.login))
    LoginView()
}




