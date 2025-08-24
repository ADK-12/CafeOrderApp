//
//  AddItemViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 25/08/25.
//

import Foundation


class AddItemViewModal {
    
    var isCustomizable = true
    var name = ""
    var price = 0
    var onDismiss: (() -> Void)?
    
    func addItemTapped(size: String, quantity: Int, finalPrice: Int) {
        var selectedSize: String?
        if isCustomizable {
            selectedSize = size
        } else {
            selectedSize = nil
        }
        
        for (index,item) in CartManager.shared.allItems.enumerated() {
            if item.name == name {
                if item.size == selectedSize {
                    CartManager.shared.allItems[index].quantity += quantity
                    onDismiss?()
                    return
                }
            }
        }
        
        CartManager.shared.allItems.append(CartItem(name: name, size: selectedSize, quantity: quantity, price: finalPrice))
        onDismiss?()
    }
    
}
