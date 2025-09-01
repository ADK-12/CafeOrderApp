//
//  ScreenManager.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 31/08/25.
//

import UIKit


class ScreenManager {
    
    private init() {}
    
    static let shared = ScreenManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let userDefaults = UserDefaults.standard

    
    func createTabBarController() -> UITabBarController {
        userDefaults.set(true, forKey: "isLoggedIn")
        
        let tabBarController = UITabBarController()
    
        let homeNavVC = storyboard.instantiateViewController(withIdentifier: "HomeNavController")
        
        let menuNavVC = storyboard.instantiateViewController(withIdentifier: "MenuNavController")
        
        let myAccountVC = storyboard.instantiateViewController(withIdentifier: "MyAccountNavController")
        
        tabBarController.viewControllers = [homeNavVC, menuNavVC, myAccountVC]
        tabBarController.modalPresentationStyle = .fullScreen
        return tabBarController
    }
    
    
    func createNewUserViewController() -> UIViewController {
        userDefaults.set(false, forKey: "isLoggedIn")
        
        return storyboard.instantiateViewController(withIdentifier: "NewUserNavController")
    }
    
}
