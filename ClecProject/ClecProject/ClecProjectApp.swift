//
//  ClecProjectApp.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 25/08/25.
//

import SwiftUI
import Firebase

@main
struct ClecProjectApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    @StateObject private var authService = AuthService()

    var body: some Scene {
        WindowGroup {
            ContentView() //<-- lembrar adicionar logica para mostrar tela de login se não estiver logado na content view
                .environmentObject(authService)
        }
    }
}
