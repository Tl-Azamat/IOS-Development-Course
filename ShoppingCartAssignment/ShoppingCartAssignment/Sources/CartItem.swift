//
//  CartItem.swift
//  ShoppingCartAssignment
//
//  Created by Азамат Тлетай on 10.10.2025.
//

import Foundation

// MARK: - CartItem Struct
struct CartItem {
    var product: Product
    private(set) var quantity: Int
    
    // Вычисляемое свойство для подсчёта суммы
    var subtotal: Double {
        return product.price * Double(quantity)
    }
    
    // Инициализатор с проверкой количества
    init?(product: Product, quantity: Int) {
        guard quantity > 0 else {
            print("Ошибка: количество должно быть больше 0 для товара \(product.name)")
            return nil
        }
        self.product = product
        self.quantity = quantity
    }
    
    // Mutating метод для изменения количества
    mutating func updateQuantity(_ newQuantity: Int) {
        guard newQuantity > 0 else {
            print("Ошибка: количество должно быть больше 0")
            return
        }
        self.quantity = newQuantity
    }
    
    // Mutating метод для увеличения количества
    mutating func increaseQuantity(by amount: Int) {
        guard amount > 0 else {
            print("Ошибка: количество для добавления должно быть больше 0")
            return
        }
        self.quantity += amount
    }
}
