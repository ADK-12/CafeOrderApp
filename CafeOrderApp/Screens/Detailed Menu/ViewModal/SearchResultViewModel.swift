//
//  SearchResultViewModel.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 21/08/25.
//

import Foundation


final class SearchResultViewModel {
    var isPresented = false

    var menu = [Menu]()
    var filteredMenu = [Menu]()
    
    var cartQuantity: Int {
        return CartManager.shared.totalQuantity
    }
}
