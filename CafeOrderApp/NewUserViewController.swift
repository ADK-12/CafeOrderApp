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

        logoImage.image = UIImage(named: "logo")
        logoImage.layer.cornerRadius = 12
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            vc.buttonTitle = "Proceed"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as? LogInViewController {
            vc.buttonTitle = "Log in"
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
