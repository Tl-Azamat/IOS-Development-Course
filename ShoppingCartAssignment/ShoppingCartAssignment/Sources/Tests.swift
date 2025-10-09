//
//  Tests.swift
//  ShoppingCartAssignment
//
//  Created by Азамат Тлетай on 10.10.2025.
//

import Foundation

// MARK: - Unit Tests
class Tests {
    
    static func runAllTests() {
        testProductCreation()
        testCartItemSubtotal()
        testAddAndRemoveFromCart()
        testCartDiscount()
        testOrderCreation()
        print("All tests completed.")
    }
    
    // MARK: - Test 1: Product Creation
    static func testProductCreation() {
        print("\n Test 1: Product Creation")
        if let product = Product(id: "P001", name: "MacBook Air", price: 999.99, category: .electronics, description: "Lightweight laptop") {
            assert(product.name == "MacBook Air")
            assert(product.price == 999.99)
            print("Product created successfully: \(product.name)")
        } else {
            print("Failed to create product")
        }
    }
    
    // MARK: - Test 2: CartItem Subtotal
    static func testCartItemSubtotal() {
        print("\n Test 2: CartItem Subtotal")
        if let product = Product(id: "P002", name: "Book", price: 50.0, category: .books, description: "Learning Swift"),
           let cartItem = CartItem(product: product, quantity: 2) {
            assert(cartItem.subtotal == 100.0)
            print("Subtotal calculation correct: \(cartItem.subtotal)")
        } else {
            print("Failed to create CartItem")
        }
    }
    
    // MARK: - Test 3: Add and Remove Items in Cart
    static func testAddAndRemoveFromCart() {
        print("\n Test 3: Add and Remove Items in Cart")
        let cart = ShoppingCart()
        if let product = Product(id: "P003", name: "iPhone", price: 1299.0, category: .electronics, description: "Smartphone") {
            cart.addItem(product: product, quantity: 1)
            assert(cart.itemCount == 1)
            print("Added 1 item to cart.")
            
            cart.removeItem(productId: "P003")
            assert(cart.itemCount == 0)
            print("Removed item from cart.")
        }
    }
    
    // MARK: - Test 4: Cart Discount
    static func testCartDiscount() {
        print("\n Test 4: Cart Discount")
        let cart = ShoppingCart()
        if let product = Product(id: "P004", name: "Headphones", price: 200.0, category: .electronics, description: "Wireless headphones") {
            cart.addItem(product: product, quantity: 2)
            cart.discountCode = "SAVE10"
            assert(cart.subtotal == 400.0)
            assert(abs(cart.total - 360.0) < 0.001) // допуск из-за double
            print("Discount applied correctly. Total: \(cart.total)")
        }
    }
    
    // MARK: - Test 5: Order Creation
    static func testOrderCreation() {
        print("\n Test 5: Order Creation")
        let cart = ShoppingCart()
        if let product = Product(id: "P005", name: "Keyboard", price: 100.0, category: .electronics, description: "Mechanical keyboard") {
            cart.addItem(product: product, quantity: 2)
            let address = Address(street: "123 Main St", city: "Almaty", state: "KZ", postalCode: "050000", country: "Kazakhstan")
            let order = Order(cart: cart, address: address)
            
            assert(order.items.count == 1)
            assert(order.total == cart.total)
            print("Order created successfully with total: \(order.total)")
        }
    }
    
}

