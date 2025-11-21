//
//  Song.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import Foundation

struct Song {
    let id: UUID = UUID()
    let title: String
    let artist: String
    let imageName: String? // имя в assets или systemName для SF Symbol
    let description: String
    let review: String
}
