//
//  FirebaseUserInfo.swift
//  Homework_1
//
//  Created by Maksim on 14.05.2021.
//

import Foundation
import Firebase

struct GroupInfoForFirebase{
    let id: Int
}

class FirebaseUserInfo {
    let id: Int
    let ref: DatabaseReference?
    
    init(id: Int ) {
        self.ref = nil
        self.id = id
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? Int else { return nil }
        
        self.ref = snapshot.ref
        self.id = id
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
        ]
    }
    
    
}
