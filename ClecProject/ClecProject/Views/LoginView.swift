//
//  LoginView.swift
//  ClecProject
//
//  Created by alsy ★ on 28/08/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var showModal = false
   // @StateObject private var projectManager = ProjectManager()
   // @StateObject private var userManager = UserManager()
    
    var body: some View {
        
        NavigationStack{
            
            VStack(spacing: 170){
                
                VStack(spacing: 30){
                    
                    Image("")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230)
                    
                    Text(",,,.")
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
                            .background(.yellow)
                            .clipShape(.buttonBorder)
                    }
                }
                .padding(.horizontal, 20)
                
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
           //.background(.blue)
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
