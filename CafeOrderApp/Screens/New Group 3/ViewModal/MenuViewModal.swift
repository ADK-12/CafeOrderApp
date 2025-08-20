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
        eventHandler?(.loading)
        Task {
            do {
                eventHandler?(.stopLoading)
                menu = try await APIManager.shared.fetchData()
                eventHandler?(.dataLoaded)
            } catch {
                eventHandler?(.error(error))
            }
        }
    }
}


extension MenuViewModal {
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
