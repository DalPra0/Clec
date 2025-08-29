//
//  CustomTabBarView.swift
//  ClecProject
//
//  Created by Giovanni Galarda Strasser on 29/08/25.
//

import SwiftUI

struct CustomNavigationBarView: View {
    let message: String?
    let title: String
    let returnText: String
    let onReturn: () -> Void
    let centerTitle: Bool
    //let backgroundColor: Color?
    
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
                HStack{
                    VStack{
                        if (message != nil) {
                            HStack{
                                Text(message ?? "")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                        HStack{
                            Text(title)
                                .fontWeight(.bold)
                                .font(.title)
                                .multilineTextAlignment(.center)
                            if(!centerTitle){
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    .foregroundColor(.black)
                    
                    Spacer()
                }
            }
            .background( Color.corCustomTabBar)
            
            
        }
        
    }
}
    
#Preview {
    VStack{
        //            CustomNavigationBarView(message: "Boa tarde", title: DeveloperHelper.project.name, returnText: "Meus Projetos", onReturn: {}, backgroundColor: nil)
        //            CustomNavigationBarView(message: "", title: "Ordem do dia", returnText: DeveloperHelper.project.name, onReturn: {}, centerTitle: false)
        //        }
        CustomNavigationBarView(message: "", title: "Insira as informações do projeto", returnText: "Voltar", onReturn: {}, centerTitle: true)
        Spacer()
    }
}
