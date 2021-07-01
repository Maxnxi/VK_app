//
//  ApiServices.swift
//  Homework_1
//
//  Created by Maksim on 22.04.2021.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage
import RealmSwift
import PromiseKit

class ApiVkServices {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.131"
    let realMServices = RealMServices()
    
    private var urlConstructor = URLComponents()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    
    init(){
        urlConstructor.scheme = "https"
        urlConstructor.host = "api.vk.com"
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    //TO DO
    func authorizationVkRequest(){
        
    }
    
    //Для ДЗ №3 - Operation
    private let queue = OperationQueue()
    
    //MARK: -> Запрос к VK серверу "friends.get"
    //ДЗ №4
    //версия 2
    func getUrl(userId:String, accessToken:String) -> Promise<URL> {
        urlConstructor.path = "/method/friends.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "fields", value: "photo"),
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "user_id", value: userId),
            URLQueryItem(name: "v", value: version),
        ]
        
        return Promise { resolver in
            guard let url = urlConstructor.url else { resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    func getData(promisedUrl url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                print("/n/n data is - ", data )
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    func getParsedData(promisedData data: Data) -> Promise<[User]> {
        return Promise { resolver in
            do {
                let response = try JSONDecoder().decode(ResponseUsers.self, from: data).response
                let usersItems = response.items
                print("/n/n ")
                resolver.fulfill(usersItems)
            } catch {
                resolver.reject(AppError.failedtoDecode)
                
            }
        }
    }
    
    func getFriends(promisedItems items: [User]) -> Promise<[UserRealMObject]> {
        return Promise<[UserRealMObject]> { resolver in
            //let friends = items.items
            var friendsForRealm:[UserRealMObject] = []
            for element in items {
                let friend = UserRealMObject(user: element)
                friendsForRealm.append(friend)
            }
            resolver.fulfill(friendsForRealm)
        }
    }
    
    //версия 1
//    func getFriends(userId: String, accessToken: String, completion: @escaping() -> Void) {
//        let path = "friends.get"
//
//        let parameters: Parameters = [
//            "user_id": userId,
//            "access_token": accessToken,
//            "v": version,
//            "fields": "photo"
//        ]
//        let url = baseUrl + path
//
//        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
//            print("request - is ", response.request!)
//
//            guard let data = response.value else { return }
//            do {
//                let friendsResponse = try JSONDecoder().decode( ResponseUsers.self, from: data).response.items
//
//                var freindsForRealm:[UserRealMObject] = []
//                for element in friendsResponse {
//                    let friend = UserRealMObject(user: element)
//                    freindsForRealm.append(friend)
//
//                    if friendsResponse.count == freindsForRealm.count {
//
//                        //записываем данные в RealM
//                        self.realMServices.saveFriendsData(freindsForRealm)
//                        completion()
//                    }
//                }
//            } catch {
//                debugPrint("error #1", error)
//            }
//        }
//    }
    
    //MARK: -> Запрос к VK серверу "groups.get"
//версия №2
//ДЗ №3
    func getUserGroups(userId: String, accessToken: String) {
   
        let getGroupDataOperation = GetGroupDataFromVKOperation(userId: userId, accessToken: accessToken)
        queue.addOperation(getGroupDataOperation)
        
        let parseGroupDataOperation = ParseGroupDataFromVKOperation<Group>()
        parseGroupDataOperation.addDependency(getGroupDataOperation)
        queue.addOperation(parseGroupDataOperation)
        
        let convertGroupToRealmObjOperation = ConvertGroupFromVKParseToRealmObjectOperation<Group>()
        convertGroupToRealmObjOperation.addDependency(parseGroupDataOperation)
        queue.addOperation(convertGroupToRealmObjOperation)
        
        let saveToRealmOperation = SaveGroupRealmObjDataToRealmOperation<Group>()
        saveToRealmOperation.addDependency(convertGroupToRealmObjOperation)
        queue.addOperation(saveToRealmOperation)
        print("getUserGroups - done")
    }
    
    // версия №1
    //    func getUserGroups(userId: String, accessToken: String, completion: @escaping() -> ()) {
//        let path = "groups.get"
//        let parameters: Parameters = [
//            "user_id": userId,
//            "access_token": accessToken,
//            "v": version,
//            "extended": "1"
//        ]
//        let url = baseUrl + path
//
//        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
//            print("request - is ", response.request!)
//            guard let data = response.value else {return}
//            do {
//                let groups = try JSONDecoder().decode( ResponseGroups.self, from: data).response.items
//                var groupsForRealm: [GroupsRealMObject] = []
//                for element in groups {
//                    let group = GroupsRealMObject(group: element)
//                    groupsForRealm.append(group)
//                    if groupsForRealm.count == groups.count {
//
//                        //записываем данные в RealM
//                        self.realMServices.saveGroupsData(groupsForRealm)
//                        completion()
//                    }
//                }
//            } catch {
//                debugPrint("error #2", error)
//            }
//        }
//    }
    
    //MARK: -> Запрос к VK серверу "photos.getAll"
    func getUserPhotos(userId: Int, accessToken: String, completion: @escaping(_ photos: [PhotoModel]) ->()) {
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
                
                var photosForNode: [PhotoModel] = []
                
                for element in photos {
                    guard let photo = PhotoModel(object: element) else { return }
                    photosForNode.append(photo)
                }
                if photosForNode.count == photos.count {
                    completion(photosForNode)
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
    func getNewsPost(startTime: String = "", startFrom: String = "", completion: @escaping(_ newsRealmObject: [NewsRealmObject], _ startFrm: String) -> ()) {
        guard let userId = Session.shared.userId,
              let accessToken = Session.shared.token else {
            print("Error #310")
            return
        }
        var newsForRealm: [NewsRealmObject] = []

            let path = "newsfeed.get"
            let parameters: Parameters = [
                "user_id": userId,
                "access_token": accessToken,
                "filters": "post", //"post,photo,photo_tag, wall_photo"
                "count": "20",
                "start_from": startFrom,
                "start_time": startTime,
                "v": self.version
            ]
            let url = self.baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData() { response in
            print("newsfeed request - is ", response.request as Any)
                guard let data = response.value else {return}
                do {
                    let response = try? JSONDecoder().decode(ResponseNews.self, from: data).response
                    
                    guard let itemsArr = response?.items,
                          let groupsArr = response?.groups,
                          let profilesArr = response?.profiles else {
                    print("Error #311")
                    return
                }
                    let startFrm: String = response?.nextFrom ?? "next_from"
                    
                    //подготавливаем данные для модели NewsRealmObject
                for element in itemsArr {
                    guard let idVk = element.sourceID else { return }
                    if idVk < 0 {
                        let additionalData = groupsArr.first(where: { $0.id == -idVk})
                        let oneNew = NewsRealmObject(news: element, additionalGroupData: additionalData)
                        newsForRealm.append(oneNew)
                    } else {
                        let additionalData = profilesArr.first(where: { $0.id == idVk})
                        let oneNew = NewsRealmObject(news: element, additionalProfileData: additionalData)
                        newsForRealm.append(oneNew)
                    }
                    if newsForRealm.count == itemsArr.count {
                        print("news downloaded - ", newsForRealm.count)
                        completion(newsForRealm, startFrm)
                    }
                }
            } catch {
                debugPrint("error #4", error)
            }
        }
    }


    

    
    
    //MARK: -> поиск группы
    
//    func getSearchCommunity(text: String?, onComplete: @escaping ([Community]) -> Void, onError: @escaping (Error) -> Void) {
//        urlConstructor.path = "/method/groups.search"
//        
//        urlConstructor.queryItems = [
//            URLQueryItem(name: "q", value: text),
//            URLQueryItem(name: "access_token", value: SessionApp.shared.token),
//            URLQueryItem(name: "v", value: constants.versionAPI),
//        ]
//        let task = session.dataTask(with: urlConstructor.url!) { (data, response, error) in
//            
//            if error != nil {
//                onError(ServerError.errorTask)
//            }
//            
//            guard let data = data else {
//                onError(ServerError.noDataProvided)
//                return
//            }
//            guard let communities = try? JSONDecoder().decode(Response<Community>.self, from: data).response.items else {
//                onError(ServerError.failedToDecode)
//                return
//            }
//            DispatchQueue.main.async {
//                onComplete(communities)
//            }
//        }
//        task.resume()
//    }
    
}
