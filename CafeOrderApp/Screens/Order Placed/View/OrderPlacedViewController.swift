//
//  OrderPlacedViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 05/08/25.
//

import UIKit


class OrderPlacedViewController: UIViewController {

    var viewModal = OrderPlacedViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModal.resetCart()
    }
    
    
    func configuration() {
        title = "Order Placed"
        
        sendOrder()
        
        if let count = navigationController?.viewControllers.count {
            navigationController?.viewControllers.remove(at: count-2)
        }
    }
    
    
    func sendOrder() {
        viewModal.placeOrder()
    }
    
}
