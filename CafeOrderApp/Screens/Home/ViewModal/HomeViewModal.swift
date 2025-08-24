//
//  HomeViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 24/08/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class HomeViewModal {
    
    var offerImages = [String]()
    
    var onError: (() -> Void)?
    var onNameFetch: ((String?) -> Void)?
    var onBirthdayFetch: ((String?) -> Void)?
    
    
    func fetchUserDetails() {
        let database = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
               
        database.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                self?.onError?()
                return
            }
            
            if let data = document?.data() {
                if let name = data["name"] as? String {
                    self?.onNameFetch?(name)
                } else {
                    self?.onNameFetch?(nil)
                }
                
                if let birthday = data["birthday"] as? String {
                    self?.onBirthdayFetch?(birthday)
                } else {
                    self?.onBirthdayFetch?(nil)
                }
            }
        }
    }
    
}
