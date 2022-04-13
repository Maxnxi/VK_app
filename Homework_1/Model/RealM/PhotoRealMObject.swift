//
//  PhotoRealMObject.swift
//  Homework_1
//
//  Created by Maksim on 30.04.2021.
//

import Foundation
import RealmSwift

class PhotoRealMObject: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var url: String = ""
            
    convenience init(userPhoto: UserPhoto) {
        self.init()
        self.id = userPhoto.id
        
        let photoSizes = userPhoto.sizes
        for element in photoSizes {
            if element.type == "x" {
                self.url = element.url
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
