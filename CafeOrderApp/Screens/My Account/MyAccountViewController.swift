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

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var birthdayButton: UIButton!
    
    let birthdayDatePicker = UIDatePicker()
    
    var userDetails = UserDetails(name: "", birthday: "", gender: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        DispatchQueue.main.async {
            self.setupUI()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI() {
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
                
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            
            if let data = document?.data() {
                if let name = data["name"] as? String {
                    self?.nameLabel.text = data["name"] as? String
                    self?.nameButton.setTitle("", for: .normal)
                    self?.nameButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                    self?.userDetails.name = name
                }
                
                if let email = data["email"] as? String {
                    self?.mailLabel.text = email
                }
                
                if let birthday = data["birthday"] as? String {
                    self?.birthdayLabel.text = birthday
                    self?.userDetails.birthday = birthday
                    
                    if birthday == "Not Provided" {
                        self?.birthdayButton.setTitle("ADD", for: .normal)
                        self?.birthdayButton.layer.cornerRadius = 20
                        self?.birthdayButton.backgroundColor = .systemBlue
                        self?.birthdayButton.setTitleColor(.white, for: .normal)
                    } else {
                        self?.birthdayButton.setTitle("", for: .normal)
                        self?.birthdayButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                    }
                }
                
                if let gender = data["gender"] as? String {
                    self?.userDetails.gender = gender
                }
            }
        }
    }
    
    
    @IBAction func nameButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Update Name", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] textField in
            textField.text = self?.userDetails.name
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let textField = ac.textFields?.first {
                if let newName = textField.text?.trimmingCharacters(in: .whitespaces) {
                    if !newName.isEmpty {
                        self?.dismiss(animated: true)
                        self?.nameLabel.text = textField.text
                        self?.userDetails.name = textField.text
                        
                        self?.updateData()
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
        
            textField.text = self?.userDetails.birthday
        
        
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
        
        userDetails.birthday = formatter.string(from: birthdayDatePicker.date)
        
        updateData()
    }
    
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    
    func updateData() {
        let db = Firestore.firestore()
                
        guard let user = Auth.auth().currentUser else {
            return
        }
                
        let userData: [String: Any] = [
            "name": userDetails.name!,
            "gender": userDetails.gender!,
            "email": user.email!,
            "birthday": userDetails.birthday!,
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
            }
        }
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
//            cartData.shared.allItems.removeAll()
            
            do {
                try Auth.auth().signOut()
                print("Logged out successfully")
                
                guard let window = self?.view.window else { return }
                weak var newUserVC = self?.storyboard?.instantiateViewController(withIdentifier: "NewUserNavController")
                window.rootViewController = newUserVC
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
