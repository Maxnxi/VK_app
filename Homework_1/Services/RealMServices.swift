//
//  RealMServices.swift
//  Homework_1
//
//  Created by Maksim on 26.04.2021.
//
import Foundation
import RealmSwift

class RealMServices {
    
    //MARK: -> Сохряняем друзей в бд
    func saveFriendsData(_ users: [UserRealMObject]) {
        do {
            let realm = try Realm()
                
            // очистка бд
            
            if realm.objects(UserRealMObject.self).count != 0 {
                _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
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
    
    //MARK: -> сохряняем Группы в бд
    func saveGroupsData(_ groups: [GroupsRealMObject]) {
        do {
            let realm = try Realm()
                
            // очистка бд
            if realm.objects(GroupsRealMObject.self).count != 0 {
                let oldGroupsRequest = realm.objects(GroupsRealMObject.self)
                realm.beginWrite()
                realm.delete(oldGroupsRequest)
                try realm.commitWrite()
            }

            // запись новых данных в бд
            realm.beginWrite()
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func loadGroupssData(completion: @escaping(_ groups: [GroupsRealMObject]) ->()) {
        do {
            let realm = try Realm()
            let groupsResult = realm.objects(GroupsRealMObject.self)
            let groupsArray = Array(groupsResult)
            debugPrint("\n\n\n loadGroupssData - done")
            completion(groupsArray)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}
