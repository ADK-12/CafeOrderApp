//
//  UserDetailViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 24/07/25.
//

import UIKit


class UserDetailViewController: UIViewController {

    var viewModal = UserDetailsViewModal()
    
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var otherButtton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var birtdayTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    let birthdayDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    func configuration() {
        signupButton.isEnabled = false
        
        nameTextField.delegate = self
        
        setupBirthdayDatePicker()
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
    
    
    @objc func doneTapped() {
        dateChanged()
        birtdayTextField.resignFirstResponder()
    }
    
    
    @objc func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
            
        birtdayTextField.text = formatter.string(from: birthdayDatePicker.date)
        viewModal.birthday = formatter.string(from: birthdayDatePicker.date)
    }
    
    
    @objc func cancelTapped() {
        birtdayTextField.text = ""
        viewModal.birthday = "Not Provided"
        birtdayTextField.resignFirstResponder()
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
    
    
    @IBAction func signupTapped(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        viewModal.name = name
        viewModal.gender = maleButton.isSelected ? "Male" : femaleButton.isSelected ? "Female" : otherButtton.isSelected ? "Other" : "Not Provided"
        
        viewModal.saveUserDetails { [weak self] error in
            if let error = error {
                let ac = UIAlertController(title: "Error saving user data", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(ac, animated: true)
            } else {
                print("User details saved successfully")
                
                let vc = ScreenManager.shared.createTabBarController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: false)
            }
        }
    }
   
}



extension UserDetailViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            if nameTextField.text != "" {
                signupButton.isEnabled = true
            } else {
                signupButton.isEnabled = false
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
