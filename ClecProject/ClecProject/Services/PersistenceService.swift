//
//  PersistenceService.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 29/08/25.
//

import Foundation

class PersistenceService {
    static let shared = PersistenceService()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Generic Save/Load Methods
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
            print("💾 [\(key)] Dados salvos com sucesso")
        } catch {
            print("❌ [\(key)] Erro ao salvar: \(error.localizedDescription)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            print("🆆 [\(key)] Nenhum dado encontrado")
            return nil
        }
        
        do {
            let object = try JSONDecoder().decode(type, from: data)
            print("✅ [\(key)] Dados carregados com sucesso")
            return object
        } catch {
            print("❌ [\(key)] Erro ao carregar: \(error.localizedDescription)")
            return nil
        }
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        print("🗑️ [\(key)] Dados removidos")
    }
    
    func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    // MARK: - Convenience Methods
    func saveString(_ string: String, forKey key: String) {
        userDefaults.set(string, forKey: key)
        print("💾 [\(key)] String salva: \(string)")
    }
    
    func loadString(forKey key: String) -> String? {
        let string = userDefaults.string(forKey: key)
        if let string = string {
            print("✅ [\(key)] String carregada: \(string)")
        } else {
            print("🆆 [\(key)] String não encontrada")
        }
        return string
    }
    
    // MARK: - Debug Methods
    func clearAll() {
        let keys = ["SavedProjects", "UserName"]
        for key in keys {
            remove(forKey: key)
        }
        print("🧹 Todos os dados de persistência foram removidos")
    }
    
    func printStorageInfo() {
        print("📊 INFORMAÇÕES DE ARMAZENAMENTO:")
        print("   - Projetos salvos: \(exists(forKey: "SavedProjects") ? "✅" : "❌")")
        print("   - Nome do usuário: \(exists(forKey: "UserName") ? "✅" : "❌")")
    }
}
