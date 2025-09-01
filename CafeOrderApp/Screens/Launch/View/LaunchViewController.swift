//
//  LaunchViewController.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 31/08/25.
//

import UIKit


class LaunchViewController: UIViewController {

    let viewModel = LaunchViewModal()
    
    @IBOutlet var cupImageView: UIImageView!
    @IBOutlet var jugImageView: UIImageView!
    @IBOutlet var coffeeImageView: UIImageView!
    @IBOutlet var jugImageViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet var cupImageViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet var cupImageViewCenterXConstraint: NSLayoutConstraint!
    @IBOutlet var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    func configuration() {
        startAnimations()
    }
    
    
    func startAnimations() {
        UIView.animate(withDuration: 1.5) {
            self.jugImageViewCenterConstraint.constant = -100
            self.cupImageView.alpha = 1.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration:0.5) {
                self.jugImageView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi)/6.2)
            } completion: { _ in
                self.startPouring()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration:0.2) {
                        self.stopPouring()
                        
                    } completion: { _ in
                        UIView.animate(withDuration:0.5) {
                            self.jugImageView.transform = .identity
                        } completion: { _ in
                            self.jugExitAndCupMorph()
                        }
                    }
                }
            }
        }
    }
    
    
    func startPouring() {
        UIView.animate(withDuration: 0.3) {
            self.coffeeImageView.alpha = 1.0
        }
    }
    
    
    func stopPouring() {
        UIView.animate(withDuration: 0.3) {
            self.coffeeImageView.alpha = 0.0
        }
    }
    
    
    func jugExitAndCupMorph() {
        UIView.animate(withDuration: 1.0) {
            self.jugImageViewCenterConstraint.constant = -500
            self.cupImageViewCenterXConstraint.constant = 5
            self.cupImageViewCenterYConstraint.constant = -18
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                self.cupImageView.alpha = 0
                self.logoImageView.alpha = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let vc = self.viewModel.screenConfiguration()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
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
