//
//  UserDetailViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 24/07/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var otherButtton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    
    @IBOutlet var birtdayTextField: UITextField!
    let birthdayDatePicker = UIDatePicker()
    
    @IBOutlet var nameTextField: UITextField!
    
    var birthday = "Not Provided"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false
        
        nameTextField.delegate = self
        
        maleButton.isSelected = false
        femaleButton.isSelected = false
        otherButtton.isSelected = false
        
        setupBirthdayDatePicker()
       
        // Do any additional setup after loading the view.
    }
    
    
    func setupBirthdayDatePicker() {
        birthdayDatePicker.datePickerMode = .date
        birthdayDatePicker.preferredDatePickerStyle = .wheels
        birthdayDatePicker.maximumDate = Date()
        birthdayDatePicker.date = Date()
        birthdayDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        toolbar.setItems([doneButton,spacer,cancelButton], animated: true)
        
        birtdayTextField.inputView = birthdayDatePicker
        birtdayTextField.inputAccessoryView = toolbar
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            if nameTextField.text != "" {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func maleTapped(_ sender: Any) {
        maleButton.isSelected = true
        femaleButton.isSelected = false
        otherButtton.isSelected = false
        
        nameTextField.endEditing(true)
    }
    
    
    @IBAction func femaleTapped(_ sender: Any) {
        femaleButton.isSelected = true
        maleButton.isSelected = false
        otherButtton.isSelected = false
        
        nameTextField.endEditing(true)
    }
    
    
    @IBAction func otherTapped(_ sender: Any) {
        otherButtton.isSelected = true
        maleButton.isSelected = false
        femaleButton.isSelected = false
        
        nameTextField.endEditing(true)
    }
    
    
    @objc func doneTapped() {
        dateChanged()
        birtdayTextField.resignFirstResponder()
    }
    
    
    @objc func cancelTapped() {
        birtdayTextField.text = ""
        birthday = "Not Provided"
        birtdayTextField.resignFirstResponder()
    }
    
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
            
        birtdayTextField.text = formatter.string(from: birthdayDatePicker.date)
        birthday = formatter.string(from: birthdayDatePicker.date)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        let db = Firestore.firestore()
        
        let name = nameTextField.text!
        let gender = maleButton.isSelected ? "Male" : femaleButton.isSelected ? "Female" : otherButtton.isSelected ? "Other" : "Not Provided"
        
        guard let user = Auth.auth().currentUser else {
            return
        }
                
        let userData: [String: Any] = [
            "name": name,
            "gender": gender,
            "email": user.email!,
            "birthday": birthday,
            "updatedAt": FieldValue.serverTimestamp()
        ]
                
        db.collection("users").document(user.uid).setData(userData) { [weak self] error in
            if let error = error {
                let ac = UIAlertController(title: "Error saving user data", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(ac, animated: true)
                return
            } else {
                print("User details saved successfully")
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey: "isLoggedIn")
                
                guard let window = self?.view.window else { return }
                guard let sceneDelegate = window.windowScene?.delegate as? SceneDelegate else { return }
                weak var tabBarController = sceneDelegate.createMainTabBarController()
                window.rootViewController = tabBarController
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
