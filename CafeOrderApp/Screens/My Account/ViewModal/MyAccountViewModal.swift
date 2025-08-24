//
//  MyAccountViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 24/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class MyAccountViewModal {
    
    var userDetails: UserDetails?
    
    var onError: ((Error?) -> Void)?
    var onDetailsFetched: (() -> Void)?
    
    var onLogoutError: ((Error?) -> Void)?
    
    
    func fetchuserDetails() {
        let database = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        database.collection("users").document(uid).getDocument { [weak self] document, error in
            if let error = error {
                self?.onError?(error)
                return
            }
            
            if let data = document?.data() {
                guard let name = data["name"] as? String,
                      let email = data["email"] as? String,
                      let birthday = data["birthday"] as? String,
                      let gender = data["gender"] as? String
                else {
                    self?.onError?(nil)
                    return
                }
                
                print("User Details Fetched Successfully")
                self?.userDetails = UserDetails(name: name, email: email, birthday: birthday, gender: gender)
                self?.onDetailsFetched?()
            }
        }
    }
    
    
    func updateUserDetails() {
        let db = Firestore.firestore()
                
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        guard let userDetails else {
            return
        }
        
        let userData: [String: Any] = [
            "name": userDetails.name,
            "gender": userDetails.gender,
            "email": userDetails.email,
            "birthday": userDetails.birthday,
            "updatedAt": FieldValue.serverTimestamp()
        ]
                
        db.collection("users").document(user.uid).setData(userData) { error in
            if let error = error {
                print("Error saving user details: \(error.localizedDescription)")
                return
            } else {
                print("User details saved successfully")
            }
        }
    }
    
    
    func logoutUser() {
        CartManager.shared.allItems.removeAll()
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            print("Logged out successfully")
            onLogoutError?(nil)
        } catch {
            onLogoutError?(error)
        }
    }
    
}
