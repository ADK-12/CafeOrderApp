//
//  UIImageViewExtension.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 21/08/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
