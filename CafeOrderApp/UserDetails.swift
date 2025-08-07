//
//  UserDetails.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 25/07/25.
//

import Foundation


class UserDetails: Codable {
    var name: String?
    var email: String?
    var gender: String?
    var birthday: Date?
    
    init(name: String!, email: String?, gender: String?, birthday: Date?) {
        self.name = name
        self.email = email
        self.gender = gender
        self.birthday = birthday
    }
}
