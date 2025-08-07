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
        
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func addDetailsTapped(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
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
