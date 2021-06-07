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
    @objc dynamic var date: String = "123"
    @objc dynamic var photoUrl: String = "https://sun1-98.userapi.com//impg//BoXabgn2xQ-nkPH9trvc_GR2FZxDu8P-HnThzA//Qsh6cfp_fFA.jpg?size=130x130&quality=96&sign=c0cddb4aec308bedfbb4b6fa745477ab&c_uniq_tag=uSdnqfN2_kT35MpBuLVNFWl65YAUEj-DnFK2f6qbVJI&type=album"
    @objc dynamic var likes: String = "123"
    @objc dynamic var comments: String = "345"
              
    convenience init(news: ItemNews) {
        self.init()
        self.id = news.sourceID ?? 0
        self.authorName = String(describing: news.sourceID ?? 0)

    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
