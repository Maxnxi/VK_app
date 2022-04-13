//
//  FirebaseModel.swift
//  Homework_1
//
//  Created by Maksim on 15.06.2021.
//

import Foundation
import Firebase

class FirebaseModel {
    
    static let instance = FirebaseModel()
    
    func startFirebaseObserve(referenceTo: DatabaseReference) -> [FirebaseUserInfo] {
        //firebase observe
        var users: [FirebaseUserInfo] = []
        referenceTo.observe(.value) { (snapshot) in
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let user = FirebaseUserInfo(snapshot: snapshot) {
                    users.append(user)
                }
            }
            print("observe firebase users - is ", users)
        }
        return users
    }
    
    func addUserInfoToFirebase(referenceTo: DatabaseReference, vkUserId: String) {
        let vkUserIdToInt = Int(vkUserId) ?? 0
        let user = FirebaseUserInfo(id: vkUserIdToInt)
        let userRef = referenceTo.child(vkUserId.lowercased())
        userRef.setValue(user.toAnyObject())
    }
}
