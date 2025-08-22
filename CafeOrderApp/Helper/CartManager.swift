//
//  CartManager.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 22/08/25.
//

import Foundation


class CartManager {
    
    private init() {}
    
    static let shared = CartManager()
    
    let userDefaults = UserDefaults.standard
    
    var allItems = [CartItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(allItems) {
                userDefaults.set(encoded, forKey: "CartItems")
            }
        }
    }
    
    var totalQuantity : Int {
        var quantity = 0
        for item in allItems {
            quantity += item.quantity
            
        }
        return quantity
    }
    
    
    func fetchCart() {
        if let savedData = userDefaults.data(forKey: "CartItems") {
            if let decoded = try? JSONDecoder().decode([CartItem].self, from: savedData) {
                allItems = decoded
                print("Cart fetched")
            }
        } else {
            print("No cart data found")
        }
    }
    
}
