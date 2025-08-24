//
//  UserDetailsViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 23/08/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class UserDetailsViewModal {
    
    var email = ""
    var password = ""
    var birthday = "Not Provided"
    var name = ""
    var gender = ""
    
    typealias Handler = ((AuthDataResult?, (any Error)?) -> Void)
    
    
    func signUpTapped(onSignup: @escaping Handler ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: onSignup)
    }
    
    
    func saveUserDetails(onSave: @escaping ((any Error)?) -> Void) {
        let database = Firestore.firestore()
        
        guard let user = Auth.auth().currentUser else {
            return
        }
                
        let userData: [String: Any] = [
            "name": name,
            "gender": gender,
            "email": email,
            "birthday": birthday,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        database.collection("users").document(user.uid).setData(userData, completion: onSave)
    }
    
}
