//
//  MyAccountViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 02/08/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyAccountViewController: UIViewController {

    var viewModal = MyAccountViewModal()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var birthdayButton: UIButton!
    
    let birthdayDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    func configuration() {
        title = "Profile"
        
        viewModal.onDetailsFetched = { [weak self] in
            guard let userDetails = self?.viewModal.userDetails else { return }
            
            self?.nameLabel.text = userDetails.name
            self?.nameButton.setTitle("", for: .normal)
            self?.nameButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            
            self?.mailLabel.text = userDetails.email
            
            self?.birthdayLabel.text = userDetails.birthday
            if userDetails.birthday == "Not Provided" {
                self?.birthdayButton.setTitle("ADD", for: .normal)
                self?.birthdayButton.layer.cornerRadius = 20
                self?.birthdayButton.backgroundColor = .systemBlue
                self?.birthdayButton.setTitleColor(.white, for: .normal)
            } else {
                self?.birthdayButton.setTitle("", for: .normal)
                self?.birthdayButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            }
        }
        
        viewModal.fetchuserDetails()
    }
    
    
    @IBAction func nameButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Update Name", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] textField in
            textField.text = self?.viewModal.userDetails?.name
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let textField = ac.textFields?.first {
                if let newName = textField.text?.trimmingCharacters(in: .whitespaces) {
                    if !newName.isEmpty {
                        self?.dismiss(animated: true)
                        self?.nameLabel.text = textField.text
                        
                        self?.viewModal.userDetails?.name = textField.text ?? ""
                        self?.viewModal.updateUserDetails()
                    }
                }
            }
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true)
    }
    

    @IBAction func birthdayButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Update Birthday", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] textField in
        
            textField.text = self?.viewModal.userDetails?.birthday
        
            self?.birthdayDatePicker.datePickerMode = .date
            self?.birthdayDatePicker.preferredDatePickerStyle = .wheels
            self?.birthdayDatePicker.maximumDate = Date()
            
            textField.inputView = self?.birthdayDatePicker
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self?.doneTapped))
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self?.cancelTapped))
            
            toolbar.setItems([doneButton,spacer,cancelButton], animated: true)
            
            textField.inputAccessoryView = toolbar
        }
        
        present(ac, animated: true)
    }
    
    
    @objc func doneTapped() {
        dismiss(animated: true)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthdayLabel.text = formatter.string(from: birthdayDatePicker.date)
        birthdayButton.layer.cornerRadius = 0
        birthdayButton.backgroundColor = .clear
        birthdayButton.setTitle("", for: .normal)
        birthdayButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        
        viewModal.userDetails?.birthday = formatter.string(from: birthdayDatePicker.date)
        viewModal.updateUserDetails()
    }
    
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            
            do {
                try self?.viewModal.logoutUser()
                print("Logged out successfully")
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                guard let window = self?.view.window else { return }
                if let newUserVC = self?.storyboard?.instantiateViewController(withIdentifier: "NewUserNavController") {
                    window.rootViewController = newUserVC
                }
            } catch {
                let ac = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self?.present(ac, animated: true)
                return
            }
        })
        
        present(ac, animated: true)
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
