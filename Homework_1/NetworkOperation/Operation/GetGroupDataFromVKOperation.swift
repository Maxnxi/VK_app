//
//  GetGroupDataFromVKOperation.swift
//  Homework_1
//
//  Created by Maksim on 10.06.2021.
//

import Foundation
import Alamofire

//TO DO - универсальный запрос и для других методов API VK

class GetGroupDataFromVKOperation: AsyncOperation {
    
    var userId: String
    var accessToken: String
    let baseUrl = "https://api.vk.com/method/"
    let path = "groups.get"
    let version = "5.130"
    var data: Data?
    
    override func main() {
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": accessToken,
            "v": version,
            "extended": "1"
        ]
        
        let url = baseUrl + path
        
        AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            print("groups request - is ", response.request)
            
            guard let data = response.value else {
                print("AF.request groups -  failed")
                return }
            self?.data = data
            print("AF.request groups -  done", data.count)
            self?.state = .finished
        }
    }
    
    init(userId: String, accessToken:String) {
        self.userId = userId
        self.accessToken = accessToken
    }
}
