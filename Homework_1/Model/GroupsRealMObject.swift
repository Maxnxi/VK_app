//
//  GroupsRealMObject.swift
//  Homework_1
//
//  Created by Maksim on 26.04.2021.
//

import Foundation
import RealmSwift

class GroupsRealMObject: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var photo: String = ""
        
    convenience init(group: Group) {
        self.init()
        self.id = group.id
        self.name = group.name
        self.photo = group.photo50
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
