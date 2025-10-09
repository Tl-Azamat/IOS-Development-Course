//
//  Product.swift
//  ShoppingCartAssignment
//
//  Created by Азамат Тлетай on 10.10.2025.
//

import Foundation

// MARK: - Product Struct
struct Product {
    let id: String
    let name: String
    let price: Double
    let category: Category
    let description: String
    
    // Категории товаров
    enum Category: String {
        case electronics
        case clothing
        case food
        case books
    }
    
    // Вычисляемое свойство для форматирования цены
    var displayPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: price)) ?? "$\(price)"
    }
    
    // Инициализатор с проверкой, что цена положительная
    init?(id: String, name: String, price: Double, category: Category, description: String) {
        guard price > 0 else {
            print("Ошибка: цена должна быть положительной для товара \(name)")
            return nil
        }
        
        self.id = id
        self.name = name
        self.price = price
        self.category = category
        self.description = description
    }
}
