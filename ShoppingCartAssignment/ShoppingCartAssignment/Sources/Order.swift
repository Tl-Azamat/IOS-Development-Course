//
//  Order.swift
//  ShoppingCartAssignment
//
//  Created by Азамат Тлетай on 10.10.2025.
//

import Foundation

// MARK: - Order Struct
struct Order {
    let id: UUID
    let items: [CartItem]
    let shippingAddress: Address
    let subtotal: Double
    let discount: Double
    let total: Double
    let date: Date
    
    init(cart: ShoppingCart, address: Address) {
        self.id = UUID()
        self.items = cart.items
        self.shippingAddress = address
        self.subtotal = cart.subtotal
        self.discount = cart.discountAmount
        self.total = cart.total
        self.date = Date()
    }
    
    // Форматированная квитанция
    func orderSummary() -> String {
        var summary = "🧾 Order ID: \(id.uuidString)\n"
        summary += "Date: \(date)\n"
        summary += "Shipping to: \(shippingAddress.formatted())\n"
        summary += "----------------------------------\n"
        for item in items {
            summary += "\(item.product.name) x\(item.quantity) - \(String(format: "%.2f", item.subtotal)) ₸\n"
        }
        summary += "----------------------------------\n"
        summary += "Subtotal: \(String(format: "%.2f", subtotal)) ₸\n"
        summary += "Discount: -\(String(format: "%.2f", discount)) ₸\n"
        summary += "Total: \(String(format: "%.2f", total)) ₸\n"
        return summary
    }
}
