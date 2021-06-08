//
//  NewsRealmObject.swift
//  Homework_1
//
//  Created by Maksim on 07.06.2021.
//

import Foundation
import RealmSwift

class NewsRealmObject: Object, Codable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var authorName: String = ""
    @objc dynamic var avatarImgUrl: String = "https://sun1-98.userapi.com//impg//BoXabgn2xQ-nkPH9trvc_GR2FZxDu8P-HnThzA//Qsh6cfp_fFA.jpg?size=130x130&quality=96&sign=c0cddb4aec308bedfbb4b6fa745477ab&c_uniq_tag=uSdnqfN2_kT35MpBuLVNFWl65YAUEj-DnFK2f6qbVJI&type=album"
    @objc dynamic var text: String = "Hello hello hello"
    @objc dynamic var date: Int = 123
    @objc dynamic var photoOneUrl: String? = ""
    //TO DO
    @objc dynamic var photoTwoUrl: String?
    @objc dynamic var photoThreeUrl: String?
    @objc dynamic var photoFourUrl: String?
        //= "https://sun1-98.userapi.com//impg//BoXabgn2xQ-nkPH9trvc_GR2FZxDu8P-HnThzA//Qsh6cfp_fFA.jpg?size=130x130&quality=96&sign=c0cddb4aec308bedfbb4b6fa745477ab&c_uniq_tag=uSdnqfN2_kT35MpBuLVNFWl65YAUEj-DnFK2f6qbVJI&type=album"
//    @objc dynamic var photoTwoUrl: String?
//    @objc dynamic var photoThreeUrl: String?
//    @objc dynamic var photoFourUrl: String?
    @objc dynamic var likes: String = "123"
    @objc dynamic var comments: String = "345"
    @objc dynamic var category: String = ""
              
    convenience init(news: ItemNews, additionalGroupData: GroupNews? = nil, additionalProfileData: Profile? = nil) {
        self.init()
        
        if additionalGroupData != nil {
            self.id = additionalGroupData?.id ?? 0
            self.authorName = additionalGroupData?.name ?? "Error loading name"
            self.avatarImgUrl = additionalGroupData?.avatarUrl ?? "profile"
            self.category = "group"
        } else if additionalProfileData != nil {
            self.id = additionalProfileData?.id ?? 0
            self.authorName = "\(additionalProfileData?.firstName) \(additionalProfileData?.lastName)"
            self.avatarImgUrl = additionalProfileData?.photo100 ?? "profile"
            self.category = "person"
        }
        
        self.text = news.text ?? "Error loading text"
        self.date = news.date ?? 0
        
        // фотография новости
        guard let phUrl = news.attachments?.compactMap({$0.photo?.sizes?.last?.url}) as? [String] else { return }
        if phUrl.count > 4 {
            photoOneUrl = phUrl[0]
            photoTwoUrl = phUrl[1]
            photoThreeUrl = phUrl[2]
            photoFourUrl = phUrl[3]
        } else if phUrl.count < 1 {
            photoOneUrl = "NO_PHOTO"
        } else if phUrl.count < 4 && phUrl.count > 1 {
            photoOneUrl = phUrl[0]
            //TO DO next
        }
       
        
        
        self.likes = "\(news.likes?.count ?? 0)"
        self.comments = "\(news.comments?.count ?? 0)"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
