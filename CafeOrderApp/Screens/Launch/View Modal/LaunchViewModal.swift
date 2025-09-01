//
//  LaunchViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 31/08/25.
//

import UIKit


class LaunchViewModal {
    
    func screenConfiguration() -> UIViewController {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        if isLoggedIn {
            return ScreenManager.shared.createTabBarController()
        } else {
            return ScreenManager.shared.createNewUserViewController()
        }
    }
    
}
