//
//  Book.swift
//  FavouritesManagerApp
//
//  Created by Азамат Тлетай on 21.11.2025.
//

import Foundation

struct Book {
    let id: UUID = UUID()
    let title: String
    let author: String
    let imageName: String? // имя в assets или systemName для SF Symbol
    let description: String
    let review: String
}
