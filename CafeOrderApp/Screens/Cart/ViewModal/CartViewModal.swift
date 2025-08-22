//
//  CartViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 22/08/25.
//

import Foundation

class CartViewModal {
    var cartItems = CartManager.shared.allItems
    
    var totalPrice: Int {
        var price = 0
        for item in cartItems {
            price += item.price * item.quantity
        }
        return price
    }
    
    func updateCart() {
        CartManager.shared.allItems = cartItems
    }
}
