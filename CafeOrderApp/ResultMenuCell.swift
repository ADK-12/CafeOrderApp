//
//  ResultMenuCell.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 28/07/25.
//

import UIKit

class CustomDataButton: UIButton {
    var isCustomizable: Bool?
    var name: String?
    var price: Int?
}

class ResultMenuCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var customizeLabel: UILabel!
    @IBOutlet var addButton: CustomDataButton!
    @IBOutlet var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
