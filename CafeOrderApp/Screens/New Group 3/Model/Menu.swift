//
//  Menu.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 26/07/25.
//

import Foundation

struct Menu: Codable {
    let type: String
    let image: String
    let items: [Item]
}

struct Item: Codable {
    let name: String
    let description: String
    let price: Int 
    let image: String
}
