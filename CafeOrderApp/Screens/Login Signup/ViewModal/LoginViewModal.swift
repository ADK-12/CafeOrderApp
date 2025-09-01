//
//  LoginViewModal.swift
//  CafeOrderApp
//
//  Created by Aditya Khandelwal on 23/08/25.
//


import Foundation
import FirebaseAuth


class LoginViewModal {
    
    var buttonTitle: String?
    var isNewUser = false
    
    typealias Handler = ((AuthDataResult?, (any Error)?) -> Void)
    
    func loginTapped(email: String, password: String, onLogin: @escaping Handler ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: onLogin)
    }
    
    func signUpTapped(email: String, password: String, onSignup: @escaping Handler ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: onSignup)
    }
    
}
