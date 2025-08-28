//
//  Menu.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 26/07/25.
//

import Foundation

struct Menu: Decodable {
    let type: String
    let image: String
    var items: [Item]
}

struct Item: Decodable {
    let name: String
    let description: String
    let price: Int 
    let image: String
    let isCustomizable: Bool
}
