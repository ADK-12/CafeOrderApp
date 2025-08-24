//
//  LogInViewController.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 10/08/25.
//

import UIKit


class LogInViewController: UIViewController {
    
    var viewModal = LoginViewModal()

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    func configuration() {
        loginButton.isEnabled = false
        loginButton.setTitle(viewModal.buttonTitle, for: .normal)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        if viewModal.isNewUser {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
                vc.viewModal.email = email
                vc.viewModal.password = password
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            viewModal.loginTapped(email: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    let ac = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                } else {
                    print("User logged in successfully")
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(true, forKey: "isLoggedIn")
                    
                    guard let window = self?.view.window else { return }
                    guard let sceneDelegate = window.windowScene?.delegate as? SceneDelegate else { return }
                    let tabBarController = sceneDelegate.createMainTabBarController()
                    window.rootViewController = tabBarController
                }
            }
        }
    }

}



extension LogInViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTextField.text != "" && emailTextField.text != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
}
