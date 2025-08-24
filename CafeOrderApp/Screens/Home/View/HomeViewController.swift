//
//  ViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 19/07/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class HomeViewController: UIViewController {
    
    var viewModal = HomeViewModal()
    
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var offerScrollView: UIScrollView!
    @IBOutlet var offerPageControl: UIPageControl!
    @IBOutlet var ajmerBannerImage: UIImageView!
    
    var offerSlideTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModal.onNameFetch = { [weak self] name in
            if let name = name {
                self?.welcomeLabel.text = "Hi \(name) welcome to"
            } else {
                self?.welcomeLabel.text = "Hi welcome to"
            }
        }
        
        viewModal.onBirthdayFetch = { [weak self] birthday in
            if let birthday = birthday {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                let currentDate = formatter.string(from: Date())
                
                let currentMonth = currentDate.components(separatedBy: .whitespaces)[1]
                let birthdayMonth = birthday.components(separatedBy: .whitespaces)[1]
                
                if birthdayMonth == currentMonth {
                    self?.viewModal.offerImages = ["birthdayOffer","offer1", "offer2", "offer3", "offer4"]
                } else {
                    self?.viewModal.offerImages = ["offer1", "offer2", "offer3", "offer4"]
                }
            } else {
                self?.viewModal.offerImages = ["offer1", "offer2", "offer3", "offer4"]
            }
            
            self?.setupOfferScrollView()
        }
        
        viewModal.fetchUserDetails()
    }
    
    
    func configuration() {
        ajmerBannerImage.layer.cornerRadius = 10
    }
    
    
    func setupOfferScrollView() {
        offerScrollView.delegate = self
        
        offerPageControl.numberOfPages = viewModal.offerImages.count
        offerPageControl.currentPage = 0
        
        let width = offerScrollView.frame.width
        let height = offerScrollView.frame.height
        offerScrollView.contentSize = CGSize(width: width * CGFloat(viewModal.offerImages.count), height: height)
        
        for i in 0..<viewModal.offerImages.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: height)
            if let image = UIImage(named: viewModal.offerImages[i]) {
                imageView.image = image
            }
            offerScrollView.addSubview(imageView)
        }
        
        startAutoSlide()
    }
    
    
    func startAutoSlide() {
        offerSlideTimer?.invalidate()
        offerSlideTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    
    @objc private func moveToNextPage() {
        let totalPages = viewModal.offerImages.count
        var nextPage = offerPageControl.currentPage + 1
        
        if nextPage >= totalPages {
            nextPage = 0
        }
        
        let xOffset = CGFloat(nextPage) * offerScrollView.frame.width
        offerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        offerPageControl.currentPage = nextPage
    }
    
    
    @IBAction func offerPageControlChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let xOffset = CGFloat(currentPage) * offerScrollView.frame.width
        offerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
                
        startAutoSlide()
    }

}


extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startAutoSlide()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(offerScrollView.contentOffset.x / offerScrollView.frame.width)
        offerPageControl.currentPage = Int(pageNumber)
        
        startAutoSlide()
    }
    
}

