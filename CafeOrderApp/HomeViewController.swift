//
//  ViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 19/07/25.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet var welcomeLabel: UILabel!
    
    @IBOutlet var offerScrollView: UIScrollView!
    @IBOutlet var offerPageControl: UIPageControl!
    
    @IBOutlet var ajmerBannerImage: UIImageView!
    
    
    var offerSlideTimer: Timer?
    
    var offerImages = [String]()
    
    var name = ""
    
    var isBirthdayMonth = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ajmerBannerImage.layer.cornerRadius = 10
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let userDetails = UserDefaults.standard.data(forKey: "userDetails") {
            if let decoded = try? JSONDecoder().decode(UserDetails.self, from: userDetails) {
                
                name = decoded.name!
                welcomeLabel.text = "Hi \(name) welcome to"
                
                if let date = decoded.birthday {
                    let month = Calendar.current.component(.month, from: date)
                    
                    if month == Calendar.current.component(.month, from: Date()) {
                        offerImages = ["birthdayOffer","offer1", "offer2", "offer3", "offer4"]
                    } else {
                        offerImages = ["offer1", "offer2", "offer3", "offer4"]
                    }
                    
                    setupOfferScrollView()
                } else {
                    offerImages = ["offer1", "offer2", "offer3", "offer4"]
                    setupOfferScrollView()
                }
            }
        }
    }
    
    
    func setupOfferScrollView() {
        
        offerScrollView.delegate = self
        
        offerPageControl.numberOfPages = offerImages.count
        offerPageControl.currentPage = 0
        
        let width = offerScrollView.frame.width
        let height = offerScrollView.frame.height
        offerScrollView.contentSize = CGSize(width: width * CGFloat(offerImages.count), height: height)
        
        for i in 0..<offerImages.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.frame = CGRect(x: width*CGFloat(i), y: 10, width: width * 0.9 , height: height * 0.9)
            if let image = UIImage(named: offerImages[i]) {
                imageView.image = image
            }
            offerScrollView.addSubview(imageView)
        }
        
        startAutoSlide()
    }
    
    
    func startAutoSlide() {
        offerSlideTimer?.invalidate()
        offerSlideTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(moveToNextPage), userInfo: nil, repeats: true)
    }
    
    
    @objc private func moveToNextPage() {
        let totalPages = offerImages.count
        var nextPage = offerPageControl.currentPage + 1
        
        if nextPage >= totalPages {
            nextPage = 0
        }
        
        let xOffset = CGFloat(nextPage) * offerScrollView.frame.width
        offerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        offerPageControl.currentPage = nextPage
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startAutoSlide()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(offerScrollView.contentOffset.x / offerScrollView.frame.width)
        offerPageControl.currentPage = Int(pageNumber)
        
        startAutoSlide()
    }
    
    
    @IBAction func offerPageControlChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let xOffset = CGFloat(currentPage) * offerScrollView.frame.width
        offerScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
                
        startAutoSlide()
    }

}

