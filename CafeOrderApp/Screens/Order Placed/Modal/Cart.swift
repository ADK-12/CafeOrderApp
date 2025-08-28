//
//  Cart.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 28/08/25.
//

import Foundation


struct Cart: Codable {
    let userId: Int
    let products: [Product]
}


struct Product: Codable {
    let id: Int
    let quantity: Int
}


struct CartResponse: Decodable {
    let id: Int
    let products: [ProductResponse]
    let total: Double
    let discountedTotal: Int
    let userId: Int
    let totalProducts: Int
    let totalQuantity: Int
}


struct ProductResponse: Decodable {
    let id: Int
    let title: String
    let price: Double
    let quantity: Int
    let total: Double
    let discountPercentage: Double
    let discountedPrice: Int
    let thumbnail: String
}

