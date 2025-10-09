//
//  Address.swift
//  ShoppingCartAssignment
//
//  Created by Азамат Тлетай on 10.10.2025.
//

import Foundation

// MARK: - Address Struct
struct Address {
    var street: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
    
    init(street: String, city: String, state: String, postalCode: String, country: String) {
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
    }
    
    // Удобное текстовое описание адреса
    func formatted() -> String {
        return "\(street), \(city), \(state), \(postalCode), \(country)"
    }
}
