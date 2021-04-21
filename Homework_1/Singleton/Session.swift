//
//  Session.swift
//  Homework_1
//
//  Created by Maksim on 08.04.2021.
// 3c0e3aa1405b73ff7224aa5c5fa6cfe324f1cb1920f84a80482ee9d876c0bcc52be4977b60f499f475aef
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
//let USER_ID = "user_id=\(Session.instance.userId)"

final class Session {
    
    static let shared = Session()
        
    var token: String?
    var userId: String?
    var dictOfUsersAvatars = Dictionary<String, UIImage>()
    
    private init() {}
    
    //MARK: -> one func for downloading Image
    
    func downloadImageByUrl(urlString: String, completion: @escaping(_ image: UIImage) -> ()) {
        AF.request(urlString).responseImage { (imageResponse) in
            guard let image = imageResponse.value else {
                    print("Error quit #001 - downloadImageByUrl - common func")
                    return}
            completion(image)
            }
        }
    
    //MARK: -> Get Friends Info
    func downloadingInfoAboutFriends(userId: String, accessToken: String, completion: @escaping(_ friendsInfoDictArray: [Dictionary<String, Any>]) -> ()) {
        var friendsInfoDictArray = [Dictionary<String, Any>]()
        
        let url = BASE_URL + GET_FRIENDS_METHOD_URL
        let parameters: Parameters = [
            "user_ids" : userId,
            "fields" : "name",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            guard let jsonResponse = response.value as? Dictionary<String, Any> else {
                print("Error quit #1")
                return
            }
            
            guard let data = jsonResponse["response"] as? Dictionary<String, Any> else {
                print("Error quit #1")
                return
            }
            
            guard let friendsArray = data["items"] as? [Dictionary<String, Any>] else { print("Error quit #2")
                return
            }
            
            for friend in friendsArray{
                guard let id = friend["id"] as? Int,
                let firstName = friend["first_name"] as? String,
                let lastName = friend["last_name"] as? String else {
                    print("Error quit #3")
                    return
                }
                
                let friendDict: Dictionary< String, Any> = [
                    "id" : id,
                    "firstName" : firstName,
                    "lastName" : lastName
                ]
                friendsInfoDictArray.append(friendDict)
            }
            completion(friendsInfoDictArray)
        }
    }
    
    func getStringOfIds(array: [Dictionary<String, Any>], completion: @escaping(_ stringOfIds: String) -> ()) {
        
        var stringArray: [String] = []
        for element in array {
            guard let id = element["id"] else {
                print("Error quit #4")
                return
            }
            let stringOfMine = "\(id)"
            stringArray.append(stringOfMine)
        }
     
        let stringOfIds = stringArray.joined(separator: ",")
        completion(stringOfIds)
    }
    
    func getUrlOfAvatarForIdDictArray(stringOfIds: String, accessToken: String, completion: @escaping(_ friendsAvatarsDictArray: [Dictionary<String, Any>]) ->()) {
        
        var friendsAvatarsDictArray = [Dictionary<String, Any>]()
        
        let url = BASE_URL + GET_USER_AVATAR_IMAGE
        let parameters: Parameters = [
            "user_ids" : stringOfIds,
            "fields" : "photo_50",
            "v" : "5.130",
            "access_token" : accessToken
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            print("getUrlOfAvatarForIdDictArray - response valu is - ", response.value)
            
            guard let json = response.value as? Dictionary<String, Any> else {
                print("Error quit #5")
                return
            }
                      
            guard let friendsInfoArray = json["response"] as? [Dictionary<String, Any>] else {
                print("Error quit #6")
                return
            }
                        
            for friend in friendsInfoArray {
                
                guard let identification = friend["id"] as? Int,
                      let firstName = friend["first_name"] as? String,
                      let lastName = friend["last_name"] as? String,
                      let imageUrl = friend["photo_50"] as? String else {
                    print("Error quit #7")
                    return
                }
                
                let friendDict: Dictionary<String, Any> = [
                    "id" : identification,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "imageUrl" : imageUrl
                ]
                friendsAvatarsDictArray.append(friendDict)
            }
            completion(friendsAvatarsDictArray)
        }
    }
       
    func getOneUserFromDict(fromDictionary dictionary: Dictionary<String, Any>, completion: @escaping(_ user: User) -> ()/*Void*/) {
        
        let id = dictionary["id"] as! Int
        let firstName = dictionary["firstName"] as! String
        let lastName = dictionary["lastName"] as! String
        let imageUrl = dictionary["imageUrl"] as! String
        
        downloadImageByUrl(urlString: imageUrl) { (imageForAvatar) in
            let user = User(identification: id, firstName: firstName, lastname: lastName, avatarImage: imageForAvatar)
            completion(user)
        }
    }

    func getFriendsArray(userId: String, accessToken: String, completion: @escaping(_ friendsArray:[User]) -> ()) {
        
        var friendsArray = [User]()
        self.downloadingInfoAboutFriends(userId: userId, accessToken: accessToken) { (arrayOfDictInfoFriends) in
            print("downloadingInfoAboutFriends - success", arrayOfDictInfoFriends.count)
            
            self.getStringOfIds(array: arrayOfDictInfoFriends) { (stringOfIds) in
                print("getStringOfIds - success", stringOfIds)
                
                self.getUrlOfAvatarForIdDictArray(stringOfIds: stringOfIds, accessToken: accessToken) { (arrayDictOfFriends) in
                    print("getUrlOfAvatarForIdDictArray - success", arrayDictOfFriends.count)
                    
                    
                    for dict in arrayDictOfFriends {
                        self.getOneUserFromDict(fromDictionary: dict) { (returnedUser) in
                                print("returnedUser - done ", returnedUser.firstName)
                                friendsArray.append(returnedUser)
                            
                            if friendsArray.count == arrayDictOfFriends.count {
                                print("myFriendsArray is - ", friendsArray.count)
                                completion(friendsArray)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: -> Get Groups of user
    
        func getUserGroupsDict(userId: String, accessToken: String, completion: @escaping(_ groupsDictArray: [Dictionary<String, Any>]) -> ()) {
            
            var groupsDictArray = [Dictionary<String, Any>]()
    //        let url = "https://api.vk.com/method/groups.get?user_id=200037963&count=3&extended=1&v=5.130&access_token=90357e2a0dd48463ecc434f006efdff8d19ddcc0acffa3cac615cb50924135f1c36d51cc4c239bc264e9e"
            let url = BASE_URL + GET_USER_GROUPS
            let parameters: Parameters = [
                "user_id" : userId,
                "extended" : "1",
                "v" : "5.130",
                "access_token" : accessToken
            ]
    
            AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
                guard let jsonResponse = response.value as? Dictionary<String, Any> else {
                    print("Error quit #11")
                    return
                }
                
                guard let data = jsonResponse["response"] as? Dictionary<String, Any> else {
                    print("Error quit #12")
                    return
                }
                
                guard let dataGroups = data["items"] as? [Dictionary<String, Any>] else {
                    print("Error quit #13")
                    return
                }
                
                for group in dataGroups {
                    guard let id = group["id"] as? Int,
                    let name = group["name"] as? String,
                    let imageUrl = group["photo_50"] as? String else {
                        print("Error quit #14")
                        return
                    }
                    
                    let groupDict: Dictionary<String, Any> = [
                        "id" : id,
                        "name" : name,
                        "imageUrl" : imageUrl
                    ]
                    groupsDictArray.append(groupDict)
                }
                completion (groupsDictArray)
            }
        }
          
    func getOneGroupFromDict(fromDictionary dictionary: Dictionary<String, Any>, completion: @escaping(_ group: Group) -> ()/*Void*/) {
        
       guard let id = dictionary["id"] as? Int,
             let name = dictionary["name"] as? String,
             let imageUrl = dictionary["imageUrl"] as? String else {
            print("Error quit #12")
            return
       }
        
        downloadImageByUrl(urlString: imageUrl) { (image) in
            let group = Group(id: id, name: name, photo: image)
            completion(group)
        }
    }
    
    func getGroupsArray(userId: String, accessToken: String, completion: @escaping(_ groupsArray: [Group]) -> ()) {
        
        var groupsArray = [Group]()
        self.getUserGroupsDict(userId: userId, accessToken: accessToken) { (arrayOfDictGroups) in
            print("getUserGroupsDict - success, ", arrayOfDictGroups.count)
            
            for group in arrayOfDictGroups{
                
                self.getOneGroupFromDict(fromDictionary: group) { (returnedGroup) in
                    print("returnedGroup - done, ", returnedGroup.name)
                    groupsArray.append(returnedGroup)
                    
                    if groupsArray.count == arrayOfDictGroups.count {
                        print("myGroupsArray is - ", groupsArray.count)
                        completion(groupsArray)
                    }
                }
            }
        }
    }
    
    //MARK: -> get photos of Friend
    
    
}
    

    
            
    
    
    
    
    
//    //MARK: -> Get Friends func
//    func getFriends(userId: String, accessToken: String, completion: @escaping(_ friendsDictArray:[User]) -> ()) {
//        var friendsArray = [User]()
////        let url = "https://api.vk.com/method/friends.get?user_id=200037963&fields=name&count=3&v=5.130&access_token=2532b87f4cfc4e8c5a71c955ec09ba469dfe7184cb0cb6791bc87af11709cdb3f108c72041d100612d6c3"
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//        var urlConstructor = URLComponents()
//        urlConstructor.scheme = "https"
//        urlConstructor.host = "api.vk.com"
//        urlConstructor.path = "/method/" + GET_FRIENDS_METHOD_URL
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "user_id", value: userId),
//            URLQueryItem(name: "fields", value: "name"),
//            URLQueryItem(name: "v", value: "5.130"),
//            URLQueryItem(name: "access_token", value: accessToken)
//        ]
//        guard let url = urlConstructor.url else { print("Error quit #1")
//            return }
//        print("\n Query: %@ ...",url )
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data,
//                  let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,Any> else {
//                print("Error quit #2")
//                return }
//            guard let responseDict = json["response"] as? Dictionary<String,Any> else {
//                print("Error quit #2.2")
//                return }
//            guard let itemDictArray = responseDict["items"] as? [Dictionary<String, Any>] else {
//                print("Error quit #3")
//                return }
//
//            let stringOfIds = self.getStringOfIds(array: itemDictArray)
//            print("stringOfIds is ---", stringOfIds)
//
//            //
//            let dictOfAvatarsUrlById = self.getUserAvatarUrl(userIds: stringOfIds, accessToken: accessToken)
//            //{ (dictOfAvatarsUrlById) in
//            print("dictOfAvatarsUrlById is - ", dictOfAvatarsUrlById.count)
//
//                for element in dictOfAvatarsUrlById {
//                    print("element is - ", element)
//                    let idKey = element.key
//                    let urlOfKey = element.value
//                    guard let imageUrl = urlOfKey as? String else {
//                            print("Error quit #4.2")
//                            return}
//
//                    self.getAvatarByUrl(url: imageUrl, accessToken: accessToken, completion: { (image) in
//                        print("imageResponse is - ", image)
//                                print("idKey is - ", idKey)
//                        //let miniDict["id"]
//                        self.dictOfUsersAvatars["\(idKey)"] = image
//                        //self.dictOfUsersAvatars.updateValue(image, forKey: idKey)
//                        print("check how was added - ", self.dictOfUsersAvatars.count)
//                            })
//                }
//
//                //print("dictOfUsersAvatars is ---", self.dictOfUsersAvatars)
//                print("dictOfUsersAvatars is -- ", self.dictOfUsersAvatars.count)
//
//                for item in itemDictArray {
//                    print("\n Donee")
//                    guard let identification = item["id"] as? Int,
//                    let firstName = item["first_name"] as? String,
//                    let lastName = item["last_name"] as? String else {
//                        print("Error quit #4")
//                        return }
//
//                    let id = "\(identification)"
//                    print("id is - ", id)
//                    print("dictOfUsersAvatars is - ", self.dictOfUsersAvatars.count)
//
//                    guard let avatarImg = self.dictOfUsersAvatars[id] as? UIImage else {
//                        print("Error quit # 10")
//                        return}
//
//                    let friend = User(identification: identification, firstName: firstName, lastname: lastName, avatarImage: avatarImg /*UIImage(named: "profileDefault")!*/ )
//                        friendsArray.append(friend)
//                }
//            print("Friends array - downloaded: ", friendsArray.count)
//            //completion(friendsArray)
//        //}
//    }.resume()
//    }
//
//    //MARK: -> get image -avatar by url
//    func downloadImageFor(url: String, accessToken: String, completion: @escaping(_ image: UIImage) -> ()) {
//        AF.request(url).responseImage { (imageResponse) in
//            guard let image = imageResponse.value else {
//                    print("Error quit #4.3")
//                    return}
//            completion(image)
//            }
//        }
//
//    //MARK: -> ids for avatar Dict
//    func getStringOfIds(array: [Dictionary<String, Any>]) -> String {
//        var stringArray:[String] = []
//        for i in 0..<array.count {
//            let tmp = array[i]
//            guard let id = tmp["id"] else {
//                print("error quit #4.4")
//                return "Error"}
//            let stringOfMine = "\(id)"
//            stringArray.append(stringOfMine)
//        }
//        let stringOfIds = stringArray.joined(separator: ",")
//        //print("\n\n stringOfIds - ", stringOfIds)
//        return stringOfIds
//    }
//
//    func getUserAvatarUrl(userIds: String, accessToken: String, completion: @escaping (_ dictOfIdsAvatars: Dictionary<String, Any>) -> ()) {
//        var dictOfIdsAvatars = Dictionary<String, Any>()
//        //        let url = "https://api.vk.com/method/users.get?access_token=986e5b8bdf46cdc6b97b05de596208a584551f57387cd3dffef00942deabe406466b21d3c5df3010d77d7&fields=photo_50&user_ids=64760%2C240782%2C433067%2C604465%2C624838%2C909910%2C973577%2C1176860%2C1265636%2C1329620%2C1377574%2C1473096%2C1501248%2C1521172%2C1649264%2C1669956%2C2647216%2C2663746%2C4090248%2C4229357%2C5593522%2C6218468%2C6875620%2C10043211%2C16739808%2C19295034%2C22247198%2C27920404%2C53122910%2C100981400%2C117669663%2C129010985%2C137150244%2C151681603%2C235839890%2C245752706%2C310148463&v=5.130"
//        //guard let userIds = userIds as? String else {return}
//        let urlForAvatar = BASE_URL + GET_USER_AVATAR_IMAGE
//        let parameters: Parameters = [
//            "user_ids" : userIds,
//            "fields" : "photo_50",
//            "v" : "5.130",
//            "access_token" : accessToken
//        ]
//
//        AF.request(urlForAvatar, method: .get, parameters: parameters).responseJSON { (response) in
//            guard let json = response.value as? Dictionary<String, Any> else {
//                print("Error quit #5")
//                return
//            }
//            print("Запрос аватарок", response.request!)
//            print("ответ аватарок", json)
//
//            guard let friendsInfoArray = json["response"] as? [Dictionary<String, Any>] else {
//                print("Error quit #6")
//                return
//            }
//
//            for number in 0..<friendsInfoArray.count {
//                guard let friend = friendsInfoArray[number] as? Dictionary<String, Any> else {
//                    print("Error quit #7")
//                    return }
//                guard let identification = friend["id"] as? Int,
//                      let imageUrl = friend["photo_50"] as? String else {
//                    print("Error quit #8")
//                    return }
//                print("here we are", identification)
//                let keyForDict = String(describing: identification)
//                print("keyForDict is - ", keyForDict)
//                dictOfIdsAvatars.updateValue(imageUrl, forKey: keyForDict) //[keyForDict] = imageUrl
//            }
//            print("completion - ", dictOfIdsAvatars)
//            //completion(dictOfIdsAvatars)
//        }
//     return dictOfIdsAvatars
//    }
//
//    //MARK: -> Get Groups of user
//
//    func getUserGroups(userId: String, accessToken: String, completion: @escaping(_ groups:[Group]) -> Void) {
////        let url = "https://api.vk.com/method/groups.get?user_id=200037963&count=3&extended=1&v=5.130&access_token=986e5b8bdf46cdc6b97b05de596208a584551f57387cd3dffef00942deabe406466b21d3c5df3010d77d7"
//
//        let url = BASE_URL + GET_USER_GROUPS
//        let parameters: Parameters = [
//            "user_id" : userId,
//            "count" : "3",
//            "extended" : "1",
//            "v" : "5.130",
//            "access_token" : accessToken
//        ]
//
//        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
//            guard let json = response.value else { return }
//            print("response of Groups - is ", response.value)
//            //let groupsArr = json["response"] //as? [Dictionary<String, AnyObject>]
//
//
//
//            print("\n Get groups - done: ", response)
//            let groups = [Group]()
//            completion(groups)
//        }
//    }
    
//    //MARK: -> Get Photos of user
//
//    func getUserPhotos(ownerId: String, accessToken: String ) {
//        //let url = "https://api.vk.com/method/photos.getAll?owner_id=__&count=3&v=5.130&access_token=__"
//
//        let url = BASE_URL + GET_USER_PHOTOS
//        let parameters: Parameters = [
//            "owner_id" : ownerId,
//            "count" : "3",
//            "v" : "5.130",
//            "access_token" : accessToken
//        ]
//
//        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
//            print("\n Get photos - done: ", response)
//        }
//    }
//
//
//
//
//
//    //MARK: -> Get groups search
//
//    func getGroupsSearch(query: String, accessToken: String) {
////        let url = "https://api.vk.com/method/groups.search?q=__&count=3&v=5.130&access_token=__"
//
//
//        let url = BASE_URL + GET_GROUPS_SEARCH
//        let parameters: Parameters = [
//            "q" : query,
//            "count" : "3",
//            "v" : "5.130",
//            "access_token" : accessToken
//        ]
//
//        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
//            print("\n Get search of Groups - done: ", response)
//        }
//    }
    

