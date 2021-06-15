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
            //self.users = users
            print("observe firebase users - is ", users)
        }
        return users
    }
    
    
    func addUserInfoToFirebase(referenceTo: DatabaseReference, vkUserId: String) {
        
//        guard let vkUserId = Session.shared.userId as? String else {
//            print("\n\n\nError 302")
//            return
//        }
        let vkUserIdToInt = Int(vkUserId) ?? 0
//        print("\n\n\n vk user id is - ", vkUserIdToInt)
        let user = FirebaseUserInfo(id: vkUserIdToInt)
        let userRef = referenceTo.child(vkUserId.lowercased())
        userRef.setValue(user.toAnyObject())
    }
    
}
