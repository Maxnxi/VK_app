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
        
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            
            guard let data = response.value else { return }
            self.data = data
            self.state = .finished
            
        }
         
    }
    
    init(userId: String, accessToken:String) {
        self.userId = userId
        self.accessToken = accessToken
    }
}


/*
 class GetDataOperation: AsyncOperation {

     override func cancel() {
         request.cancel()
         super.cancel()
     }
     
     private var request: DataRequest
     var data: Data?
     
     override func main() {
         request.responseData(queue: DispatchQueue.global()) { [weak self] response in
             self?.data = response.data
             self?.state = .finished
         }
     }
     
     init(request: DataRequest) {
         self.request = request
     }
     
 }
 */