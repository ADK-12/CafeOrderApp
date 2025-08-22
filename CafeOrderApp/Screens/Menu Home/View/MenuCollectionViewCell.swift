//
//  MenuCollectionViewCell.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 21/08/25.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet var cellBackgroundView: UIView!
    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    
    var menu: Menu? {
        didSet {
            cellConfiguration()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 15
        menuImageView.layer.cornerRadius = 10
        // Initialization code
    }
    
    
    func cellConfiguration() {
        guard let menu else { return }
        
        menuImageView.setImage(urlString: menu.image)
        menuLabel.text = menu.type
    }

}
