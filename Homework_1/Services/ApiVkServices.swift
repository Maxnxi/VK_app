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
    
    //MARK: -> Logout from VK
    
    //https://login.vk.com/?act=logout&hash=bbf6e9bd4f095255c9&_origin=https%3A%2F%2Fvk.com&reason=tn
    func logOutFromVkServer() {
       
        let url = "https://login.vk.com/?act=logout&hash=bbf6e9bd4f095255c9&_origin=https%3A%2F%2Fvk.com&reason=tn"
        
        AF.request(url)
    }
    
    //MARK: -> Запрос к VK серверу "newsfeed.get" / данные в Realm сохраняем
    func getNewsPost(userId: String, accessToken: String, completion: @escaping() -> Void) {
        //https://api.vk.com/method/newsfeed.get?access_token=23f5d9413b77384e80cd010e98d870716da2c4a25a1b70758f3dd345b0bb84600b4cde496a6c1374ce9d9&count=2&filters=post,photo&user_id=200037963&v=5.130
        
        //Dispatch Group ДЗ №2
        let dispatchGroup = DispatchGroup()
        var newsForRealm: [NewsRealmObject] = []

            let path = "newsfeed.get"
            let parameters: Parameters = [
                "user_id": userId,
                "access_token": accessToken,
                "filters": "post",
                "count": "10",
                "v": self.version
            ]
            let url = self.baseUrl + path
            
        
            AF.request(url, method: .get, parameters: parameters).responseData { (response) in
                print("request - is ", response.request!)
                guard let data = response.value else {return}
                do {
                    //ДЗ №2
//                    DispatchQueue.global().async(group: dispatchGroup) {
                    let items = try JSONDecoder().decode( ResponseNews.self, from: data).response?.items
                    let groups = try JSONDecoder().decode( ResponseNews.self, from: data).response?.groups
                    let profiles = try JSONDecoder().decode( ResponseNews.self, from: data).response?.profiles
//                    }
                guard let itemsArr = items as? [ItemNews],
                      let groupsArr = groups as? [GroupNews],
                      let profilesArr = profiles as? [Profile] else {
                    print("Error #311")
                    return
                }
                
                    //подготавливаем данные для модели NewsRealmObject
                for element in itemsArr {
                    guard let idVk = element.sourceID as? Int else { return }
                    if idVk < 0 {
                        let additionalData = groups?.first(where: { $0.id == -idVk})
                        let oneNew = NewsRealmObject(news: element, additionalGroupData: additionalData)
                        newsForRealm.append(oneNew)
                    } else {
                        let additionalData = profiles?.first(where: { $0.id == idVk})
                        let oneNew = NewsRealmObject(news: element, additionalProfileData: additionalData)
                        newsForRealm.append(oneNew)
                    }
                    if newsForRealm.count == itemsArr.count {
                        
                        //записываем данные в RealM
                        DispatchQueue.main.async {
                            self.realMServices.saveNewsData(newsForRealm)
                            completion()
                        }
                        
                    }
                }
            } catch {
                debugPrint("error #4", error)
            }
            }
//        }
        
//        dispatchGroup.notify(queue: DispatchQueue.main) {
//            //записываем данные в RealM
//            self.realMServices.saveNewsData(newsForRealm)
//        }
    }

    
    func getNewsPhoto(userId: String, accessToken: String, completion: @escaping() -> Void) {
        
        let path = "newsfeed.get"
        
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": accessToken,
            "filters": "photo",
            "count": "1",
            "v": version
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            print("request - is ", response.request!)
            // TO DO PARSE DATA
            
        }
    }
    
    
    //MARK: -> для реализации в будущем
    func downloadImageByUrl(urlString: String, completion: @escaping(_ image: UIImage) -> ()) {
            AF.request(urlString).responseImage { (imageResponse) in
                guard let image = imageResponse.value else {
                        print("Error quit #001 - downloadImageByUrl - common func")
                        return}
                completion(image)
                }
            }
    
}
