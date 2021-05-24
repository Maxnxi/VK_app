//
//  ApiServices.swift
//  Homework_1
//
//  Created by Maksim on 22.04.2021.
//

import Foundation
import Alamofire
import AlamofireImage
import RealmSwift

class ApiVkServices {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.130"
    let realMServices = RealMServices()
    
    //MARK: -> Запрос к VK серверу "friends.get"
    func getFriends(userId: String, accessToken: String, completion: @escaping() -> Void) {
        let path = "friends.get"
        
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": accessToken,
            "v": version,
            "fields": "photo"
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            print("request - is ", response.request!)
            
            guard let data = response.value else { return }
            do {
                let friendsResponse = try JSONDecoder().decode( ResponseUsers.self, from: data).response.items
                
                var freindsForRealm:[UserRealMObject] = []
                for element in friendsResponse {
                    let friend = UserRealMObject(user: element)
                    freindsForRealm.append(friend)
                    
                    if friendsResponse.count == freindsForRealm.count {
                        
                        //записываем данные в RealM
                        self.realMServices.saveFriendsData(freindsForRealm)
                        completion()
                    }
                }
            } catch {
                debugPrint("error #1", error)
            }
        }
    }
    
    //MARK: -> Запрос к VK серверу "groups.get"
    func getUserGroups(userId: String, accessToken: String, completion: @escaping() -> ()) {
        let path = "groups.get"
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": accessToken,
            "v": version,
            "extended": "1"
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            print("request - is ", response.request!)
            guard let data = response.value else {return}
            do {
                let groups = try JSONDecoder().decode( ResponseGroups.self, from: data).response.items
                var groupsForRealm: [GroupsRealMObject] = []
                for element in groups {
                    let group = GroupsRealMObject(group: element)
                    groupsForRealm.append(group)
                    if groupsForRealm.count == groups.count {
                        
                        //записываем данные в RealM
                        self.realMServices.saveGroupsData(groupsForRealm)
                        completion()
                    }
                }
            } catch {
                debugPrint("error #2", error)
            }
        }
    }
    
    //MARK: -> Запрос к VK серверу "photos.getAll"
    func getUserPhotos(userId: Int, accessToken: String, completion: @escaping() ->()) {
        let path = "photos.getAll"
        let parameters: Parameters = [
            "owner_id": userId,
            "access_token": accessToken,
            "no_service_albums": 0,
            "count": 100,
            "v": version,
            "extended": 1,
            "photo_sizes": 1
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            guard let data = response.value else {return}
            do {
                let photos = try JSONDecoder().decode( ResponseUserPhotos.self, from: data).response.items
                var photosForRealm: [PhotoRealMObject] = []
                for element in photos {
                    let photo = PhotoRealMObject(userPhoto: element)
                    photosForRealm.append(photo)
                    if photosForRealm.count == photos.count {
                        
                        //to do save photos to realM
                        self.realMServices.saveUrlPhotosToRealm(photosForRealm)
                        completion()
                    }
                }
            } catch {
                debugPrint("error #3", error)
            }
        }
    }
    
    //MARK: -> Запрос к серверу VK новостная лента
    
    func getNewsfeed(userId: String, accessToken: String, completion: @escaping() -> Void) {
        //https://api.vk.com/method/newsfeed.get?access_token=68309aa52ce45fb18e5625696a5e43a884671ee994af76857e89ea5d8c24706b2bc902effdc29e9aef5ab&count=10&filters=post&source_ids=friends&user_id=200037963&v=5.130
        
        //https://api.vk.com/method/newsfeed.get?user_id=200037963&access_token=68309aa52ce45fb18e5625696a5e43a884671ee994af76857e89ea5d8c24706b2bc902effdc29e9aef5ab&filters=post&count=3&v=5.130
        
        
        let path = "newsfeed.get"
        
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": accessToken,
            "v": version,
            "filters": "post",
            "source_ids": "friends",
            "count": "10"
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            print("request - is ", response.request!)
            
            guard let data = response.value else { return }
            
        }
    }

    
}
