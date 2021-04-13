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

import Foundation
import Alamofire

let BASE_URL = "https://api.vk.com/method/"
let GET_FRIENDS_METHOD_URL = "friends.get"
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
    
    func getFriends(userId: String, accessToken: String) {
//        let url = "https://api.vk.com/method/friends.get?user_id=__&fields=name&count=3&v=5.130&access_token=__"
        let url = BASE_URL + GET_FRIENDS_METHOD_URL
        let parameters: Parameters = [
            "user_id" : userId,
            "fields" : "name",
            "count" : "3",
            "v" : "5.130",
        "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get friends - done: ", response)
        }
    }
    
    
    //MARK: -> Get Photos of user
    
    func getUserPhotos(ownerId: String) {
        //let url = "https://api.vk.com/method/photos.getAll?owner_id=200037963&count=3&v=5.130&access_token=e6727660911aaad2a9593dfaa44cfcede254163561e5075a15a0055093ad8c35cbfd7d277f4b503d5bf7b"
        
        let url = BASE_URL + GET_USER_PHOTOS
        let parameters: Parameters = [
            "owner_id" : ownerId,
            "count" : "3",
            "v" : "5.130",
            "access_token" : "e6727660911aaad2a9593dfaa44cfcede254163561e5075a15a0055093ad8c35cbfd7d277f4b503d5bf7b"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get photos - done: ", response)
        }
    }
    
    
    //MARK: -> Get Groups of user
    
    func getUserGroups(userId: String) {
//        let url = "https://api.vk.com/method/groups.get?user_id=200037963&count=3&extended=1&v=5.130&access_token=e6727660911aaad2a9593dfaa44cfcede254163561e5075a15a0055093ad8c35cbfd7d277f4b503d5bf7b"
        
        let url = BASE_URL + GET_USER_GROUPS
        let parameters: Parameters = [
            "user_id" : userId,
            "count" : "3",
            "extended" : "1",
            "v" : "5.130",
        "access_token" : "e6727660911aaad2a9593dfaa44cfcede254163561e5075a15a0055093ad8c35cbfd7d277f4b503d5bf7b"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get groups - done: ", response)
        }
    }
    
    
    //MARK: -> Get groups search
    
    func getGroupsSearch(query: String) {
//        let url = "https://api.vk.com/method/groups.search?q=Music&count=3&v=5.130&access_token=e6727660911aaad2a9593dfaa44cfcede254163561e5075a15a0055093ad8c35cbfd7d277f4b503d5bf7b"
        
        let url = BASE_URL + GET_GROUPS_SEARCH
        let parameters: Parameters = [
            "q" : query,
            "count" : "3",
            "v" : "5.130",
            "access_token" : "e6727660911aaad2a9593dfaa44cfcede254163561e5075a15a0055093ad8c35cbfd7d277f4b503d5bf7b"
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("\n Get search of Groups - done: ", response)
        }
    }
    
}
