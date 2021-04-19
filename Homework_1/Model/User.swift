//
//  User.swift
//  Homework_1
//
//  Created by Maksim on 25.02.2021.
//

import Foundation
import UIKit

class User {
    
    public private(set) var identification: Int
    public private(set) var firstName: String
    public private(set) var lastName: String
    public private(set) var avatarImage: UIImage
    
    var fullName: String {
        let fstName = firstName
        let lstName = lastName
        return String("\(lstName) \(fstName) ")
    }
    
    init(identification: Int, firstName: String, lastname: String, avatarImage: UIImage) {
        self.identification = identification
        self.firstName = firstName
        self.lastName = lastname
        self.avatarImage = avatarImage
    }
    
//    static func friendsLoad(friendData: [User]) {
//        self.friends = friendData
//    }
    
}
