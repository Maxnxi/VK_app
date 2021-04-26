//
//  RealMServices.swift
//  Homework_1
//
//  Created by Maksim on 26.04.2021.
//
import Foundation
import RealmSwift

class RealMServices {
    
    func saveFriendsData(_ users: [UserRealMObject]) {
        
        do {
            let realm = try Realm()
                
            // очистка бд
            _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
            if realm.objects(UserRealMObject.self).count != 0 {
                let oldUsersRequest = realm.objects(UserRealMObject.self)
                realm.beginWrite()
                realm.delete(oldUsersRequest)
                try realm.commitWrite()
            }
            
            // запись новых данных в бд
            realm.beginWrite()
            realm.add(users)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func loadFriendsData(completion: @escaping(_ users: [UserRealMObject]) ->()) {
        
        do {
            let realm = try Realm()
            let usersResult = realm.objects(UserRealMObject.self)
            
            let usersArray = Array(usersResult)
            debugPrint("\n\n\n loadFriendsData - done")
            completion(usersArray)
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
}
