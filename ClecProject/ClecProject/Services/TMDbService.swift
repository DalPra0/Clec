//
//  TMDbService.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 31/08/25.
//

import Foundation
import Combine

class TMDbService: ObservableObject {
    static let shared = TMDbService()
    
    // 🔑 CONFIGURAÇÃO DA API KEY - SIGA ESTES PASSOS:
    // 
    // 1. Vá em: https://www.themoviedb.org/signup (conta gratuita)
    // 2. Depois de confirmar email, vá em: Settings → API
    // 3. Clique "Create" e preencha o formulário
    // 4. Copie a API Key gerada (32 caracteres)
    // 5. SUBSTITUA "SEU_API_KEY_AQUI" pela sua key real abaixo:
     
    private let apiKey = "224a7d2a8fb337415c793280d3dfa12a"  // ⚠️ COLE SUA API KEY AQUI!
    
    private let baseURL = "https://api.themoviedb.org/3"
    private var cancellables = Set<AnyCancellable>()
    
    var isUsingRealAPI: Bool {
        return apiKey != "SEU_API_KEY_AQUI" && apiKey != "demo_key" && !apiKey.isEmpty
    }
    
    private init() {
        if isUsingRealAPI {
            print("🔑 API TMDb CONFIGURADA - Usando API key real")
        } else {
            print("🎭 MODO DEMO - Configure sua API key em TMDbService.swift")
            print("🔗 Instruções: https://www.themoviedb.org/settings/api")
        }
    }
    
    func searchMovies(query: String) -> AnyPublisher<[Movie], Error> {
        guard !query.isEmpty else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        guard isUsingRealAPI else {
            return searchMockMovies(query: query)
        }
        
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=pt-BR&include_adult=false&page=1"
        
        print("🔍 Buscando na API: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            return Fail(error: TMDbError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 401 {
                        throw TMDbError.unauthorizedAPIKey
                    } else if httpResponse.statusCode != 200 {
                        throw TMDbError.networkError("HTTP \(httpResponse.statusCode)")
                    }
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📥 Resposta recebida: \(jsonString.prefix(200))...")
                }
                
                return data
            }
            .decode(type: TMDbSearchResponse.self, decoder: JSONDecoder())
            .tryMap { response -> [Movie] in
                print("✅ Filmes encontrados: \(response.results.count)")
                return response.results
            }
            .catch { error -> AnyPublisher<[Movie], Error> in
                print("❌ Erro na API: \(error.localizedDescription)")
                
                return self.searchMockMovies(query: query)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func searchMockMovies(query: String) -> AnyPublisher<[Movie], Error> {
        let filteredMovies = getMockMovies().filter { movie in
            movie.title.lowercased().contains(query.lowercased())
        }
        
        print("🎭 Usando dados mock, encontrados: \(filteredMovies.count) filmes para '\(query)'")
        
        return Just(filteredMovies)
            .delay(for: 0.3, scheduler: DispatchQueue.main)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getPopularMovies() -> AnyPublisher<[Movie], Error> {
        guard isUsingRealAPI else {
            print("🎭 Usando filmes populares mock")
            return Just(Array(getMockMovies().prefix(10)))
                .delay(for: 0.3, scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&language=pt-BR&page=1"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: TMDbError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Popular Movies Status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 401 {
                        throw TMDbError.unauthorizedAPIKey
                    } else if httpResponse.statusCode != 200 {
                        throw TMDbError.networkError("HTTP \(httpResponse.statusCode)")
                    }
                }
                return data
            }
            .decode(type: TMDbSearchResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .catch { error -> AnyPublisher<[Movie], Error> in
                print("❌ Erro ao buscar filmes populares: \(error)")
                return Just(Array(self.getMockMovies().prefix(10)))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func testAPIKey() -> AnyPublisher<Bool, Never> {
        guard isUsingRealAPI else {
            return Just(false)
                .eraseToAnyPublisher()
        }
        
        let urlString = "\(baseURL)/configuration?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Just(false)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { _, response -> Bool in
                if let httpResponse = response as? HTTPURLResponse {
                    let isValid = httpResponse.statusCode == 200
                    print(isValid ? "✅ API Key válida!" : "❌ API Key inválida (Status: \(httpResponse.statusCode))")
                    return isValid
                }
                return false
            }
            .catch { error -> Just<Bool> in
                print("❌ Erro ao testar API Key: \(error)")
                return Just(false)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getMockMovies() -> [Movie] {
        return [
            Movie(
                id: 550,
                title: "Clube da Luta",
                overview: "Um funcionário de escritório insone e um fabricante de sabão formam um clube de luta clandestino que se transforma em algo muito maior.",
                posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
                backdropPath: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
                releaseDate: "1999-10-15",
                voteAverage: 8.4,
                voteCount: 26280
            ),
            Movie(
                id: 680,
                title: "Pulp Fiction",
                overview: "As vidas de dois assassinos da máfia, um boxeador, a esposa de um gângster e dois assaltantes se entrelaçam em quatro histórias de violência e redenção.",
                posterPath: "/dM2w364MScsjFf8pfMbaWUcWrR.jpg",
                backdropPath: "/suaEOtk1N1sgg2MTM7oZd2cfVp3.jpg",
                releaseDate: "1994-10-14",
                voteAverage: 8.5,
                voteCount: 27280
            ),
            Movie(
                id: 13,
                title: "Forrest Gump",
                overview: "A vida extraordinária de um homem simples que, sem perceber, influencia eventos históricos importantes dos Estados Unidos.",
                posterPath: "/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg",
                backdropPath: "/7c9UVPPiTPltouxRVY6N9ZX0z4J.jpg",
                releaseDate: "1994-07-06",
                voteAverage: 8.5,
                voteCount: 26800
            ),
            Movie(
                id: 155,
                title: "Batman - O Cavaleiro das Trevas",
                overview: "Batman enfrenta o Coringa, um criminoso psicopata que quer mergulhar Gotham City no caos.",
                posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
                backdropPath: "/hqkIcbrOHL86UncnHIsHVcVmzue.jpg",
                releaseDate: "2008-07-18",
                voteAverage: 9.0,
                voteCount: 32100
            ),
            Movie(
                id: 278,
                title: "Um Sonho de Liberdade",
                overview: "Dois homens presos se relacionam ao longo de vários anos, encontrando consolo e eventual redenção através de atos de decência comum.",
                posterPath: "/9cqNxx0GxF0bflyCy3NpwJ7Ixid.jpg",
                backdropPath: "/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg",
                releaseDate: "1994-09-23",
                voteAverage: 9.3,
                voteCount: 26000
            ),
            Movie(
                id: 238,
                title: "O Poderoso Chefão",
                overview: "O patriarca de uma dinastia de crime organizado transfere o controle de seu império clandestino para seu filho relutante.",
                posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
                backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
                releaseDate: "1972-03-14",
                voteAverage: 8.7,
                voteCount: 18800
            ),
            Movie(
                id: 424,
                title: "A Lista de Schindler",
                overview: "A história real de como Oskar Schindler salvou mais de mil judeus do Holocausto.",
                posterPath: "/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg",
                backdropPath: "/zb6fM1CX41D9rF9hdgclu0peUmy.jpg",
                releaseDate: "1993-11-30",
                voteAverage: 8.6,
                voteCount: 15000
            ),
            Movie(
                id: 389,
                title: "12 Homens e uma Sentença",
                overview: "Um júri deve decidir o destino de um jovem acusado de homicídio.",
                posterPath: "/ow3wq89wM8qd5X7hWKxiRfsFf9C.jpg",
                backdropPath: "/qqHQsStV6exghCM7zbObuYBiYxw.jpg",
                releaseDate: "1957-04-10",
                voteAverage: 8.5,
                voteCount: 8200
            ),
            Movie(
                id: 129,
                title: "A Viagem de Chihiro",
                overview: "Uma menina de 10 anos entra em um mundo governado por deuses, bruxas e espíritos.",
                posterPath: "/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg",
                backdropPath: "/mnpRKVSXBX6jb56nabvmGKA0Wig.jpg",
                releaseDate: "2001-07-20",
                voteAverage: 8.5,
                voteCount: 14500
            ),
            Movie(
                id: 19404,
                title: "Dilema das Redes",
                overview: "Especialistas em tecnologia soam o alarme sobre suas próprias criações.",
                posterPath: "/uQr14EDcvYXy9ZYhVanPbHJBDIf.jpg",
                backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
                releaseDate: "2020-01-26",
                voteAverage: 7.6,
                voteCount: 2100
            )
        ]
    }
}

enum TMDbError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    case unauthorizedAPIKey
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida para a API"
        case .noData:
            return "Nenhum dado recebido da API"
        case .decodingError:
            return "Erro ao processar dados da API"
        case .networkError(let message):
            return "Erro de rede: \(message)"
        case .unauthorizedAPIKey:
            return "API Key inválida. Verifique sua chave em TMDbService.swift"
        }
    }
}
