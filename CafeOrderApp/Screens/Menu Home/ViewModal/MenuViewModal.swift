//
//  MenuViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 20/08/25.
//

import Foundation


final class MenuViewModal {
    var menu = [Menu]()
    
    var onMenuFetch: ((_ event: Event) -> Void)? // Data Binding Closure
    
    var cartQuantity: Int {
        return CartManager.shared.totalQuantity
    }
    
    func fetchMenu() {
        Task {
            do {
                onMenuFetch?(.loading)
                menu = try await APIManager.shared.fetchData()
                onMenuFetch?(.dataLoaded)
            } catch {
                onMenuFetch?(.error(error))
            }
        }
    }
    
    
    func fetchCart() {
        CartManager.shared.fetchCart()
    }
}


extension MenuViewModal {
    enum Event {
        case loading
        case dataLoaded
        case error(Error?)
    }
}
