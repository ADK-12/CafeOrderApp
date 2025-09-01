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
            viewModal.signUpTapped(email: email, password: password) { [weak self] AuthDataResult, error in
                if let error = error {
                    let ac = UIAlertController(title: "Signup Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                } else {
                    print("User Signed up successfully")
                    
                    if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            }
        } else {
            viewModal.loginTapped(email: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    let ac = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                } else {
                    print("User logged in successfully")
                    
                    let vc = ScreenManager.shared.createTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: false)
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
