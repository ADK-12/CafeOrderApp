//
//  MyAccountViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 02/08/25.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var mailButton: UIButton!
    @IBOutlet var birthdayButton: UIButton!
    
    let birthdayDatePicker = UIDatePicker()
    
    var user: UserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI() {
        if let userDetails = UserDefaults.standard.data(forKey: "userDetails")  {
            if let userData = try? JSONDecoder().decode(UserDetails.self, from: userDetails) {
                
                user = userData
                
                nameLabel.text = userData.name
                nameButton.setTitle("", for: .normal)
                nameButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                
                if let email = userData.email {
                    mailLabel.text = email
                    mailButton.setTitle("", for: .normal)
                    mailButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                } else {
                    mailLabel.text = "Not Provided"
                    mailButton.setTitle("ADD", for: .normal)
                    mailButton.layer.cornerRadius = 20
                    mailButton.backgroundColor = .systemBlue
                    mailButton.setTitleColor(.white, for: .normal)
                }
                
                if let birthday = userData.birthday {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .none
                        
                    birthdayLabel.text = formatter.string(from: birthday)
                    birthdayButton.setTitle("", for: .normal)
                    birthdayButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                } else {
                    birthdayLabel.text = "Not Provided"
                    birthdayButton.setTitle("ADD", for: .normal)
                    birthdayButton.layer.cornerRadius = 20
                    birthdayButton.backgroundColor = .systemBlue
                    birthdayButton.setTitleColor(.white, for: .normal)
                }
            }
        }
        
    }
    
    
    @IBAction func nameButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Update Name", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] textField in
            textField.text = self?.user?.name
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let textField = ac.textFields?.first {
                if let newName = textField.text {
                    if !newName.isEmpty {
                        self?.dismiss(animated: true)
                        self?.nameLabel.text = newName
                        self?.user!.name = newName
                        
                        self?.saveToUserDefaults()
                    }
                }
            }
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        
        present(ac, animated: true)
    }
    
    
    @IBAction func mailButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Update E-mail", message: nil, preferredStyle: .alert)
        ac.addTextField { [weak self] textField in
            textField.text = self?.user?.email
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            if let textField = ac.textFields?.first {
                if let newMail = textField.text {
                    if !newMail.isEmpty {
                        self?.dismiss(animated: true)
                        self?.mailLabel.text = newMail
                        self?.user!.email = newMail
                        
                        self?.saveToUserDefaults()
                        self?.mailButton.layer.cornerRadius = 0
                        self?.mailButton.backgroundColor = .clear
                        self?.mailButton.setTitle("", for: .normal)
                        self?.mailButton.setImage(UIImage(systemName: "pencil"), for: .normal)
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
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            textField.text = formatter.string(from: self?.user?.birthday ?? Date()) 
        
        
            self?.birthdayDatePicker.datePickerMode = .date
            self?.birthdayDatePicker.preferredDatePickerStyle = .wheels
            self?.birthdayDatePicker.maximumDate = Date()
            self?.birthdayDatePicker.date = self?.user?.birthday ?? Date()
            
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
        
        user?.birthday = birthdayDatePicker.date
        
        saveToUserDefaults()
    }
    
    
    @objc func cancelTapped() {
        dismiss(animated: true)
    }
    
    
    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(user) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encoded, forKey: "userDetails")
        }
    }
    
    
    @IBAction func logoutTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Logout", style: .destructive) { [weak self] _ in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            cartData.shared.allItems.removeAll()
            
            guard let window = self?.view.window else { return }
            weak var newUserVC = self?.storyboard?.instantiateViewController(withIdentifier: "NewUserNavController")
            window.rootViewController = newUserVC
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
