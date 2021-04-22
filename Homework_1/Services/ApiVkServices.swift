//
//  ApiServices.swift
//  Homework_1
//
//  Created by Maksim on 22.04.2021.
//

import Foundation
import Alamofire
import AlamofireImage

class ApiVkServices {
    
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.130"
    
    //MARK: -> Запрос к VK серверу "friends.get"
    func getFriends(userId: String, accessToken: String, completion: @escaping([User]) -> Void) {
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
                let friends = try JSONDecoder().decode( ResponseUsers.self, from: data).response.items
                completion(friends)
            } catch {
                debugPrint("error #1", error)
            }
        }
    }
    
    //MARK: -> Запрос к VK серверу "groups.get"
    func getUserGroups(userId: String, accessToken: String, completion: @escaping(_ groups:[Group]) -> ()) {
        let path = "groups.get"
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": accessToken,
            "v": version,
            "extended": "1"
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            guard let data = response.value else {return}
            do {
                let groups = try JSONDecoder().decode( ResponseGroups.self, from: data).response.items
                
                //print("Succes - ", friends.first ?? 0)
                completion(groups)
            } catch {
                debugPrint("error #2", error)
            }
        }
        
    }
    
    //MARK: -> Запрос к VK серверу "photos.getAll"
    func getUserPhotos(userId: Int, accessToken: String, completion: @escaping(_ userPhotos:[UserPhoto]) ->()) {
        let path = "photos.getAll"
        let parameters: Parameters = [
            "owner_id": userId,
            "access_token": accessToken,
            "no_service_albums": 0,
            "count": 10,
            "v": version,
            "extended": 1,
            "photo_sizes": 1
        ]
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { (response) in
            
            print("request photos  is - ", response.request)
            guard let data = response.value else {return}
            do {
                let photos = try JSONDecoder().decode( ResponseUserPhotos.self, from: data).response.items
                completion(photos)
            } catch {
                debugPrint("error #3", error)
            }
            
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
