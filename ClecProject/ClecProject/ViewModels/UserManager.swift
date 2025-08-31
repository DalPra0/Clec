//
//  UserManager.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation
import SwiftUI

class UserManager: ObservableObject {
    @Published var userName: String = "Nome padrao"
    
    private let userDefaults = UserDefaults.standard
    private let userNameKey = "UserName"
    
    init() {
        loadUserName()
    }
    
    func updateUserName(_ name: String) {
        userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        saveUserName()
        print("👤 Nome do usuário atualizado para: \(userName)")
    }
    
    private func loadUserName() {
        if let savedName = userDefaults.string(forKey: userNameKey), !savedName.isEmpty {
            userName = savedName
            print("👤 Nome carregado: \(userName)")
        } else {
            userName = "Nome Padrao" // Default name
            print("👤 Usando nome padrão: \(userName)")
        }
    }
    
    private func saveUserName() {
        userDefaults.set(userName, forKey: userNameKey)
        print("💾 Nome salvo: \(userName)")
    }
    
    var greeting: String {
        return "Hello, \(userName)!"
    }
    
    func resetToDefault() {
        userName = "Mia"
        saveUserName()
        print("🔄 Nome resetado para padrão: Mia")
    }
}
