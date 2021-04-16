//
//  User.swift
//  Homework_1
//
//  Created by Maksim on 25.02.2021.
//

import Foundation

class User {
    var identification: Int?
    var firstName: String?
    var lastName: String?
    
    
    init(identification: Int, firstName: String, lastname: String) {
        self.identification = identification
        self.firstName = firstName
        self.lastName = lastname
    }
}
