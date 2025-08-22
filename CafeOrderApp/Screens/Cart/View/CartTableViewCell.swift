//
//  CartTableViewCell.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 23/08/25.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var customStepper: UIStackView!
    
    var cartItem: CartItem? {
        didSet {
            cellConfiguration()
        }
    }
    
    var onMinusTap: (() -> Void)?
    var onPlusTap: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customStepper.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func cellConfiguration() {
        guard let cartItem else { return }
        
        if let size = cartItem.size {
            nameLabel.text = cartItem.name + "-(\(size))"
        } else {
            nameLabel.text = cartItem.name
        }
        
        quantityLabel.text = "\(cartItem.quantity)"
        priceLabel.text = "₹\(cartItem.price * cartItem.quantity)"
    }
    
    
    @IBAction func minusTapped(_ sender: Any) {
        onMinusTap?()
    }
    
    
    @IBAction func plusTapped(_ sender: Any) {
        onPlusTap?()
    }
    
}
