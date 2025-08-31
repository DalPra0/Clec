//
//  MovieModel.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 31/08/25.
//

import Foundation

// MARK: - Movie Model
struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    
    // Computed properties for easier access
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
    
    var year: String {
        guard let releaseDate = releaseDate,
              let year = releaseDate.prefix(4).isEmpty ? nil : String(releaseDate.prefix(4)) else {
            return "N/A"
        }
        return year
    }
    
    var formattedTitle: String {
        return "\(title) (\(year))"
    }
    
    // JSON mapping
    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - TMDb Search Response
struct TMDbSearchResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Favorite Movie (for local storage)
struct FavoriteMovie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?
    let year: String
    
    init(from movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.year = movie.year
    }
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}
