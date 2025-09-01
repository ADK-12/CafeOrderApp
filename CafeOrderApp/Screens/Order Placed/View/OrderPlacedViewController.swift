//
//  OrderPlacedViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 05/08/25.
//

import UIKit


class OrderPlacedViewController: UIViewController {

    var viewModal = OrderPlacedViewModal()
    
    @IBOutlet var orderPlacedImageView: UIImageView!
    @IBOutlet var orderConfirmedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        
        // Do any additional setup after loading the view.
    }
    
    
    func configuration() {
        sendOrder()
        
        if let count = navigationController?.viewControllers.count {
            navigationController?.viewControllers.remove(at: count-2)
        }
    }
    
    
    func sendOrder() {
        viewModal.onConfirmed = { [weak self] in
            self?.viewModal.resetCart()
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
                    self?.orderPlacedImageView.transform = CGAffineTransform(scaleX: 200, y: 200)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self?.orderConfirmedLabel.alpha = 1
                    }
                }
            }
        }
        
        viewModal.placeOrder()
    }
    
}
