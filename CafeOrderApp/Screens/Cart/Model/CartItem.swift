//
//  CartData.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 01/08/25.
//

import Foundation

struct CartItem: Codable {
    let name: String
    let size: String?
    var quantity: Int
    let price: Int
}


