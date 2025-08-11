//
//  LogInViewController.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 10/08/25.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var buttonTitle: String?

    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.isEnabled = false
        loginButton.setTitle(buttonTitle!, for: .normal)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if passwordTextField.text != "" && emailTextField.text != "" {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        if buttonTitle == "Proceed" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
                if let error = error {
                    let ac = UIAlertController(title: "Signup Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(ac, animated: true)
                } else {
                    print("User signed up successfully")
                    
                    if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
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
                    weak var tabBarController = sceneDelegate.createMainTabBarController()
                    window.rootViewController = tabBarController
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
