//
//  Session.swift
//  Homework_1
//
//  Created by Maksim on 08.04.2021.
//
//6. Получение списка друзей;+
//7. Получение фотографий человека;+
//8. Получение групп текущего пользователя;+
//9. Получение групп по поисковому запросу;+
//10. Вывести данные в консоль.+

import UIKit
import Foundation
import Alamofire

let BASE_URL = "https://api.vk.com/method/"
let GET_FRIENDS_METHOD_URL = "friends.get"
let GET_USER_AVATAR_IMAGE = "users.get"
let GET_USER_PHOTOS = "photos.getAll"
let GET_USER_GROUPS = "groups.get"
let GET_GROUPS_SEARCH = "groups.search"

let USER_ID = "user_id=\(Session.instance.userId)"


final class Session {
    static let instance = Session()
    
    private init() {}
    
    var token: String?
    var userId: String?
    
    
    //MARK: -> Get Friends func
    
    func getFriends(userId: String, accessToken: String, completion: @escaping(_ friendsDictArray:[User]) -> ()) {
        
        var friendsArray = [User]()
//        let url = "https://api.vk.com/method/friends.get?user_id=200037963&fields=name&count=3&v=5.130&access_token=d1a3b94ad2222cb5198530fba2cdb94cb8dbf8e22aaf505e670d7ec80a772ac693ad5c24610936dd757cc"
        
        // let str = String(describing: strToDecode.cString(using: String.Encoding.utf8))
        
  //using Alamofire
//        let url = BASE_URL + GET_FRIENDS_METHOD_URL
//        let parameters: Parameters = [
//            "user_id" : userId,
//            "fields" : "name",
//            "count" : "3",
//            "v" : "5.130",
//        "access_token" : accessToken
//        ]
//        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
//
//            print("\n Get friends - done: ", response)
//        }
        
        //using URLSession
        let  configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        var urlConstructor = URLComponents()
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        urlConstructor.path = "/method/" + GET_FRIENDS_METHOD_URL
        urlConstructor.queryItems = [
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "fields", value: "name"),
            URLQueryItem(name: "v", value: "5.130"),
            URLQueryItem(name: "access_Token", value: accessToken)
        ]
        guard let url = urlConstructor.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, respose, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any> else { return }
            
            guard let itemDictArray = json["items"] as? [Dictionary<String, AnyObject>] else { return }
            
            for itemDictionary in itemDictArray {
                guard let identification = itemDictionary["id"] as? Int,
                let firstName = itemDictionary["first_name"] as? String,
                let lastName = itemDictionary["last_name"] as? String else { return }
                
                let friend = User(identification: identification, firstName: firstName, lastname: lastName)
                friendsArray.append(friend)
            }
            completion(friendsArray)
        }.resume()
    }
    
    func getUserAvatarImage(userIds: Int, accessToken: String, completion: @escaping (_ image: UIImage) -> ()) {
        //let url = "https://api.vk.com/method/users.get?user_ids=200037963&fields=photo_50&v=5.130&access_token=d1a3b94ad2222cb5198530fba2cdb94cb8dbf8e22aaf505e670d7ec80a772ac693ad5c24610936dd757cc"
        
        let url = BASE_URL + GET_USER_AVATAR_IMAGE
        let parameters: Parameters = [
            "user_ids" : userId,
            "fields" : "photo_50",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseImage { (response) in
           
           // print("\n Get users Avatars - done: ", response)
            
            
            
        }
    }
    
    
    //MARK: -> Get Photos of user
    
    func getUserPhotos(ownerId: String, accessToken: String ) {
        //let url = "https://api.vk.com/method/photos.getAll?owner_id=__&count=3&v=5.130&access_token=__"
        
        let url = BASE_URL + GET_USER_PHOTOS
        let parameters: Parameters = [
            "owner_id" : ownerId,
            "count" : "3",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get photos - done: ", response)
        }
    }
    
    
    //MARK: -> Get Groups of user
    
    func getUserGroups(userId: String, accessToken: String) {
//        let url = "https://api.vk.com/method/groups.get?user_id=__&count=3&extended=1&v=5.130&access_token=__"
        
        let url = BASE_URL + GET_USER_GROUPS
        let parameters: Parameters = [
            "user_id" : userId,
            "count" : "3",
            "extended" : "1",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get groups - done: ", response)
        }
    }
    
    
    //MARK: -> Get groups search
    
    func getGroupsSearch(query: String, accessToken: String) {
//        let url = "https://api.vk.com/method/groups.search?q=__&count=3&v=5.130&access_token=__"
        
        let url = BASE_URL + GET_GROUPS_SEARCH
        let parameters: Parameters = [
            "q" : query,
            "count" : "3",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get search of Groups - done: ", response)
        }
    }
    
}
