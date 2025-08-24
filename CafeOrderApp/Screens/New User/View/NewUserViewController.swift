//
//  NewUserViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 24/07/25.
//

import UIKit


class NewUserViewController: UIViewController {

    @IBOutlet var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    func configuration() {
        logoImage.image = UIImage(named: "logo")
        logoImage.layer.cornerRadius = 12
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            vc.viewModal.buttonTitle = "Proceed"
            vc.viewModal.isNewUser = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            vc.viewModal.buttonTitle = "Log in"
            vc.viewModal.isNewUser = false
            navigationController?.pushViewController(vc, animated: true)
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
