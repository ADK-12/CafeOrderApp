//
//  EndPointType.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 28/08/25.
//

import Foundation


enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}


protocol EndPointType {
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Codable? { get }
    var headers: [String: String]? { get }
}


enum EndPointItems {
    case menu
    case cart(cart: Cart)
}


extension EndPointItems: EndPointType {
    
    var url: URL? {
        switch self {
        case .menu:
            return URL(string: menuURL)
        case .cart:
            return URL(string: cartURL)
        }
    }
    
    var method: HTTPMethods {
        switch self {
        case .menu:
            return .get
        case .cart:
            return .post
        }
    }
    
    var body: (any Codable)? {
        switch self {
        case .menu:
            return nil
        case .cart(cart: let cart):
            return cart
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .menu:
            return nil
        case .cart:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
}
