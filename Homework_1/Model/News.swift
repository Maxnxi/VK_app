//
//  News.swift
//  Homework_1
//
//  Created by Maksim on 19.03.2021.
//

import Foundation
import UIKit

class News {
    
    var newsAuthorFullName: String
    var newsAuthorAvatarView: String
    var newsDate: String
    var newsLabel: String
    var newImage: String
    var counterOfSeen: Int
    var counterOfLike: Int
    var counterOfComments:Int

    init(author: Friend, date: String, news: String, image: String, counterOfSeen: Int, counterOfLike: Int, counterOfComments: Int) {
        self.newsAuthorFullName = author.fullName
        self.newsAuthorAvatarView = author.avatarImg
        self.newsDate = date
        self.newsLabel = news
        self.newImage = image
        self.counterOfSeen = counterOfSeen
        self.counterOfLike = counterOfLike
        self.counterOfComments = counterOfComments
    }
    
}

extension News {
    
    static let news1 = News(author: Friend.carl, date: "19.03.2021", news: "Первый пост о прелести программирования на Swift!", image: "news_photo_1", counterOfSeen: 65535, counterOfLike: 256, counterOfComments: 5)
    static let news2 = News(author: Friend.friend20, date: "19.03.2021", news: "Удаленка - это прекрасно!", image: "news_photo_2", counterOfSeen: 65535, counterOfLike: 256, counterOfComments: 5)
    
    
    static func newsDataLoad() -> [News] {
        return [news1,news2,news1,news1,news1,news1,]
    }
    
}
