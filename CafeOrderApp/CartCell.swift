//
//  CartCell.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 01/08/25.
//

import UIKit

class CartDataButton: UIButton {
    var index: Int?
    var quantity: Int?
}

class CartCell: UITableViewCell {
   
    @IBOutlet var customStepper: UIStackView!
    @IBOutlet var name: UILabel!
    @IBOutlet var quantityLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var minusButton: CartDataButton!
    @IBOutlet var plusButton: CartDataButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customStepper.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
