//
//  UserDetails.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 25/07/25.
//

import Foundation


class UserDetails {
    var name: String?
    var birthday: String?
    var gender: String?
    
    init(name: String!, birthday: String?, gender: String?) {
        self.name = name
        self.birthday = birthday
        self.gender = gender
    }
}
