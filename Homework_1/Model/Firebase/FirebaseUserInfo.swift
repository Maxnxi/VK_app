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
    var communities: [FirebaseCommunity] = []
    let ref: DatabaseReference?
    var toFire: [String: Any] {
        return communities.map{ $0.toAnyObject()}.reduce([:]) { $0.merging($1) { (current, _) in current } }
    }
       
    
    init(id: Int ) {
        self.ref = nil
        self.id = id
        self.communities = []
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? Int,
              let communities = value["communities"] as? [FirebaseCommunity] else { return nil }
        
        self.ref = snapshot.ref
        self.id = id
        self.communities = communities
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "communities": toFire
        ]
    }
}
