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
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
                
            // очистка бд
            
//            if realm.objects(UserRealMObject.self).count != 0 {
//                _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
//                let oldUsersRequest = realm.objects(UserRealMObject.self)
//                realm.beginWrite()
//                realm.delete(oldUsersRequest)
//                try realm.commitWrite()
//            }
            
            // запись новых данных в бд
            realm.beginWrite()
            realm.add(users, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
//    func loadFriendsData(completion: @escaping(_ users: [UserRealMObject]) ->()) {
//        do {
//            let realm = try Realm()
//            let usersResult = realm.objects(UserRealMObject.self)
//            let usersArray = Array(usersResult)
//            debugPrint("\n\n\n loadFriendsData - done")
//            completion(usersArray)
//        } catch {
//            debugPrint(error.localizedDescription)
//        }
//    }
    
    //MARK: -> сохряняем Группы в бд
    func saveGroupsData(_ groups: [GroupsRealMObject]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
                
            // очистка бд
//            if realm.objects(GroupsRealMObject.self).count != 0 {
//                let oldGroupsRequest = realm.objects(GroupsRealMObject.self)
//                realm.beginWrite()
//                realm.delete(oldGroupsRequest)
//                try realm.commitWrite()
//            }

            // запись новых данных в бд
            realm.beginWrite()
            realm.add(groups, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
//    func loadGroupssData(completion: @escaping(_ groups: [GroupsRealMObject]) ->()) {
//        do {
//            let realm = try Realm()
//            let groupsResult = realm.objects(GroupsRealMObject.self)
//            let groupsArray = Array(groupsResult)
//            debugPrint("\n\n\n loadGroupssData - done")
//            completion(groupsArray)
//        } catch {
//            debugPrint(error.localizedDescription)
//        }
//    }
    
    //MARK: -> сохраняем новости в бд
    
    func saveNewsData(_ news: [NewsRealmObject]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
            let oldValues = realm.objects(NewsRealmObject.self)

            realm.beginWrite()
            realm.delete(oldValues)
            realm.add(news)
            try realm.commitWrite()
            print("News save in realm - ", news)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    //MARK: -> сохраняем url фото в бд
    func saveUrlPhotosToRealm(_ photos: [PhotoRealMObject]) {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)

//             очистка бд
                        if realm.objects(PhotoRealMObject.self).count != 0 {
                            _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
                            let oldPhotosRequest = realm.objects(PhotoRealMObject.self)
                            realm.beginWrite()
                            realm.delete(oldPhotosRequest)
                            try realm.commitWrite()
                            print("/n/n/n oldPhotosRequest - deleted")
                        }
            
            
            // запись новых данных в бд
            realm.beginWrite()
            realm.add(photos, update: .all)
            try realm.commitWrite()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func clearPhotoRealm() {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: config)
            
            if realm.objects(PhotoRealMObject.self).count != 0 {
                _ = try Realm.deleteFiles(for: Realm.Configuration.defaultConfiguration)
                let oldPhotosRequest = realm.objects(PhotoRealMObject.self)
                realm.beginWrite()
                realm.delete(oldPhotosRequest)
                try realm.commitWrite()
                print("/n/n/n oldPhotosRequest - deleted")
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
}
