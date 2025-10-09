//
//  ShoppingCart.swift
//  ShoppingCartAssignment
//
//  Created by Азамат Тлетай on 10.10.2025.
//

import Foundation

// MARK: - ShoppingCart Class
class ShoppingCart {
    // Приватное хранение элементов, чтобы защитить от прямого изменения
    private(set) var items: [CartItem] = []
    var discountCode: String?
    
    // Инициализация пустой корзины
    init() {}
    
    // Добавить товар в корзину
    func addItem(product: Product, quantity: Int = 1) {
        // Проверяем, есть ли уже этот товар в корзине
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            // Увеличиваем количество
            items[index].increaseQuantity(by: quantity)
        } else {
            // Создаём новый CartItem
            if let newItem = CartItem(product: product, quantity: quantity) {
                items.append(newItem)
            }
        }
    }
    
    // Удалить товар из корзины
    func removeItem(productId: String) {
        items.removeAll { $0.product.id == productId }
    }
    
    // Обновить количество товара
    func updateItemQuantity(productId: String, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == productId }) {
            if quantity == 0 {
                removeItem(productId: productId)
            } else {
                items[index].updateQuantity(quantity)
            }
        }
    }
    
    // Очистить корзину
    func clearCart() {
        items.removeAll()
    }
    
    // Вычисляемое свойство для суммы без скидки
    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    // Вычисляемое свойство для суммы скидки
    var discountAmount: Double {
        guard let code = discountCode else { return 0 }
        switch code.uppercased() {
        case "SAVE10": return subtotal * 0.10
        case "SAVE20": return subtotal * 0.20
        default: return 0
        }
    }
    
    // Общая сумма после скидки
    var total: Double {
        return subtotal - discountAmount
    }
    
    // Количество товаров в корзине
    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    // Проверка, пуста ли корзина
    var isEmpty: Bool {
        return items.isEmpty
    }
}

