//
//  Session.swift
//  Homework_1
//
//  Created by Maksim on 08.04.2021.
//


import UIKit
import Foundation
import Alamofire
import AlamofireImage

let BASE_URL = "https://api.vk.com/method/"
let GET_FRIENDS_METHOD_URL = "friends.get"
let GET_USER_AVATAR_IMAGE = "users.get"
let GET_USER_PHOTOS = "photos.getAll"
let GET_USER_GROUPS = "groups.get"
let GET_GROUPS_SEARCH = "groups.search"

let USER_ID = "user_id=\(Session.instance.userId)"

var dictOfUsersAvatars = Dictionary<String, Any>()

final class Session {
    static let instance = Session()
    
    private init() {}
    
    var token: String?
    var userId: String?
    
    
    //MARK: -> Get Friends func
    
    func getFriends(userId: String, accessToken: String, completion: @escaping(_ friendsDictArray:[User]) -> ()) {
        
        var friendsArray = [User]()
        
//        let url = "https://api.vk.com/method/friends.get?user_id=200037963&fields=name&count=3&v=5.130&access_token=2532b87f4cfc4e8c5a71c955ec09ba469dfe7184cb0cb6791bc87af11709cdb3f108c72041d100612d6c3"
        
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
            URLQueryItem(name: "access_token", value: accessToken)
        ]
        guard let url = urlConstructor.url else { print("Error quit #1")
            return }
        print("\n Query: %@ ...",url )
        
        URLSession.shared.dataTask(with: url) { (data, respose, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any> else {
                print("Error quit #2")
                return }
            //print(json["response"])
            guard let responseDict = json["response"] as? Dictionary<String,Any> else {
                print("Error quit #2.2")
                return }
            
            guard let itemDictArray = responseDict["items"] as? [Dictionary<String, Any>] else {
                print("Error quit #3")
                return }
            
            let stringOfIds = self.getStringOfIds(array: itemDictArray)
            print("stringOfIds is ---", stringOfIds)
            
            self.getUserAvatarUrl(userIds: stringOfIds, accessToken: accessToken) { (dictOfAvatarsUrlById) in
                print("dictOfAvatarsUrlById is -", dictOfAvatarsUrlById)
                for element in dictOfAvatarsUrlById {
                    
//                    let id = dictOfAvatarsUrlById[keySmall]
                        print("element is - ", element)
                    let idKey = element.key
                    let urlOfKey = element.value
                    
                        guard let imageUrl = urlOfKey /*dictOfAvatarsUrlById[keySmall]*/ as? String else {
                            print("Error quit #4.2")
                            return}
                    
                        
                            self.getAvatarByUrl(url: imageUrl, accessToken: accessToken, completion: { (imageResponse) in
                                print("imageResponse is - ", imageResponse.size)
                                print("idKey is - ", idKey)
                                dictOfUsersAvatars.updateValue(imageResponse, forKey: idKey)
                                //[idKey] = imageResponse
                                print("check how was added - ", dictOfUsersAvatars.capacity)
                            })
                }
                
                print("dictOfUsersAvatars is ---", dictOfUsersAvatars)
            }
            print("dictOfUsersAvatars is -", dictOfUsersAvatars.count)
            //sleep(10)
            
            // Ошибка здесь
            
            for item in itemDictArray {
                
                print("\n Donee")
                guard let identification = item["id"] as? Int,
                let firstName = item["first_name"] as? String,
                let lastName = item["last_name"] as? String else {
                    print("Error quit #4")
                    return }
                
                let firstNameEncodedUtf = firstName
                let lastNameEncodedUtf = lastName
//                let firstNameEncodedUtf = String(describing: firstName.cString(using: String.Encoding.utf8))
//                let lastNameEncodedUtf = String(describing: lastName.cString(using: String.Encoding.utf8))

                let id = "\(identification)"
                print("id is - ", id)
                //print("dictOfUsersAvatars is - ", dictOfUsersAvatars)
//                guard let imageAvatar = dictOfUsersAvatars[id] else {
//                    print("Error quit $4.1")
//                    return }
                
 
                let friend = User(identification: identification, firstName: firstNameEncodedUtf, lastname: lastNameEncodedUtf, avatarImage: UIImage(named: "profileDefault")! )
                    friendsArray.append(friend)
            }
            print("Friends array - downloaded: ", friendsArray.count /*, friendsArray[0].firstName*/)
            completion(friendsArray)
        }.resume()
    }
    
    //MARK: -> get image -avatar by url
    func getAvatarByUrl(url: String, accessToken: String, completion: @escaping(_ image: UIImage) -> ()) {
        AF.request(url).responseImage { (imageResponse) in
            guard let image = imageResponse.value  else {
                    print("Error quit #4.3")
                    return}
            completion(image)
            }
        }
    
    //MARK: -> ids for avatar Dict
    func getStringOfIds(array: [Dictionary<String, Any>]) -> String {
        
        // String of ids for avatar Query
        var stringArray:[String] = []
        for i in 0..<array.count {
            let tmp = array[i]
            guard let id = tmp["id"] else {break}
            let stringOfMine = "\(id)"
            //print("\n\n\n my string is:", stringOfMine)
            stringArray.append(stringOfMine)
        }
        let stringOfIds = stringArray.joined(separator: ",")
        print("\n\n stringOfIds - ", stringOfIds)
        return stringOfIds
    }
    
    func getUserAvatarUrl(userIds: String, accessToken: String, completion: @escaping (_ dictOfIdsAvatars: Dictionary<String,Any>) -> ()) {
        
        var dictOfIdsAvatars: Dictionary<String, Any> = [:]
//        let url = "https://api.vk.com/method/users.get?access_token=986e5b8bdf46cdc6b97b05de596208a584551f57387cd3dffef00942deabe406466b21d3c5df3010d77d7&fields=photo_50&user_ids=64760%2C240782%2C433067%2C604465%2C624838%2C909910%2C973577%2C1176860%2C1265636%2C1329620%2C1377574%2C1473096%2C1501248%2C1521172%2C1649264%2C1669956%2C2647216%2C2663746%2C4090248%2C4229357%2C5593522%2C6218468%2C6875620%2C10043211%2C16739808%2C19295034%2C22247198%2C27920404%2C53122910%2C100981400%2C117669663%2C129010985%2C137150244%2C151681603%2C235839890%2C245752706%2C310148463&v=5.130"

        guard let userIds = userIds as? String else {return}
        let urlForAvatar = BASE_URL + GET_USER_AVATAR_IMAGE
        let parameters: Parameters = [
            "user_ids" : userIds,
            "fields" : "photo_50",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(urlForAvatar, method: .get, parameters: parameters).responseJSON { (response) in
            guard let json = response.value as? Dictionary<String, Any> else {
                print("Error quit #5")
                return
            }
            print("Запрос аватарок", response.request!)
            print("ответ аватарок", json)
            
            guard let friendsInfoArray = json["response"] as? [Dictionary<String, Any>] else {
                print("Error quit #6")
                return
            }
            
            for number in 0..<friendsInfoArray.count {
                guard let friend = friendsInfoArray[number] as? Dictionary<String, Any> else {return}
                guard let identification = friend["id"] as? Int,
                      let imageUrl = friend["photo_50"] as? String else {return}
                print("here we are", identification)
                let keyForDict = String(describing: identification)
                print("keyForDict is - ", keyForDict)
                dictOfIdsAvatars.updateValue(imageUrl, forKey: keyForDict) //[keyForDict] = imageUrl
            }
            print("completion - ", dictOfIdsAvatars)
            completion(dictOfIdsAvatars)
        }
        
       
        
    }
    
    
    
    
    
//
    
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
