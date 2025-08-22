//
//  MenuTableViewCell.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 21/08/25.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var customizeLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    
    var item: Item? {
        didSet {
            cellConfiguration()
        }
    }
    
    var onButtonTap: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemImageView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func cellConfiguration() {
        guard let item else { return }
        
        titleLabel.text = item.name
        priceLabel.text = "₹\(item.price)"
        descriptionLabel.text = item.description
        itemImageView.setImage(urlString: item.image)
        customizeLabel.isHidden = !item.isCustomizable
    }
    
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        onButtonTap?()
    }
    
}
