//
//  OrderPlacedViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 23/08/25.
//

import Foundation


class OrderPlacedViewModal {
    var cartResponse: CartResponse?
    
    func placeOrder() {
        Task {
            do {
                print("Placing Order...")
                //sample cart just to show POST API calls
                let cart = Cart(userId: 1, products: [Product(id: 144, quantity: 4)])
                cartResponse = try await APIManager.shared.request(modalType: CartResponse.self, type: EndPointItems.cart(cart: cart))
                print("Order Placed Successfully")
                
                if let response = cartResponse {
                    print("Order", response)
                }
                
            } catch {
                print("order placed failed:", error)
            }
        }
    }
    
    
    func resetCart() {
        CartManager.shared.allItems.removeAll()
    }
    
}
