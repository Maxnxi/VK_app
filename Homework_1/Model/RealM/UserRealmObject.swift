//
//  UserRealmObject.swift
//  Homework_1
//
//  Created by Maksim on 26.04.2021.
//

import Foundation
import RealmSwift

class UserRealMObject: Object, Codable {
    
    @objc dynamic var firstName: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo: String = ""
          
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
              
    convenience init(user: User) {
        self.init()
        self.firstName = user.firstName
        self.id = user.id
        self.lastName = user.lastName
        self.photo = user.photo
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

