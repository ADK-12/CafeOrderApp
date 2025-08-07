//
//  Menu.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 26/07/25.
//

import Foundation

struct Menu: Codable {
    var menu: [SubMenu]
}

struct SubMenu: Codable {
    let type: String
    var items: [MenuItem]
}

struct MenuItem: Codable {
    let name: String
    let description: String
    let price: Int 
    let image: String
}
