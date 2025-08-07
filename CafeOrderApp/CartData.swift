//
//  CartData.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 01/08/25.
//

import Foundation

struct item {
    let name: String
    let size: String?
    var quantity: Int
    let price: Int
}

class cartData {
    static let shared = cartData()
    
    init() {
    }
    
    var allItems = [item]()
    var totalQuantity : Int {
        var quantity = 0
        for item in allItems {
            quantity += item.quantity
            
        }
        return quantity
    }
    var totalPrice: Int {
        var price = 0
        for item in allItems {
            price += item.price * item.quantity
        }
        return price
    }
    
}
