//
//  MenuViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 20/08/25.
//

import Foundation


final class MenuViewModal {
    var menu = [Menu]()
    
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func fetchMenu() {
        Task {
            do {
                eventHandler?(.loading)
                menu = try await APIManager.shared.fetchData()
                eventHandler?(.dataLoaded)
            } catch {
                eventHandler?(.error(error))
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
