//
//  FirebaseCommunity.swift
//  Homework_1
//
//  Created by Maksim on 01.07.2021.
//

import Foundation
import Firebase

class FirebaseCommunity {
    
    let name: String
    let id: Int
    let ref: DatabaseReference?
    
    init(name: String, id: Int) {

        self.ref = nil
        self.name = name
        self.id = id
    }
    
    init?(snapshot: DataSnapshot) {

        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.id = id
    }
    
    func toAnyObject() -> [String: Any] {

        return [
            "name": name,
            "id": id
        ]
    }
}
