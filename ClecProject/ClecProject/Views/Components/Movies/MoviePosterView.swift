//
//  MoviePosterView.swift
//  ClecProject
//
//  Created by Lucas Dal Pra Brascher on 31/08/25.
//

import SwiftUI

struct MoviePosterView: View {
    let movie: FavoriteMovie?
    let size: CGSize
    let cornerRadius: CGFloat
    
    init(movie: FavoriteMovie?, size: CGSize = CGSize(width: 80, height: 120), cornerRadius: CGFloat = 8) {
        self.movie = movie
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Group {
            if let movie = movie {
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "photo")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                Text(movie.title)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .padding(4)
                        )
                }
            } else {
                // Empty slot
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 20))
                                .foregroundColor(.gray.opacity(0.7))
                            Text("Adicionar")
                                .font(.caption2)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    )
            }
        }
        .frame(width: size.width, height: size.height)
        .cornerRadius(cornerRadius)
        .clipped()
    }
}
