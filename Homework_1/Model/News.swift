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
    var newsAuthorAvatarView: UIImage
    var newsDate: String
    var newsLabel: String
    var newImage: String
    var counterOfSeen: Int
    var counterOfLike: Int
    var counterOfComments:Int

    init(author: User, date: String, news: String, image: String, counterOfSeen: Int, counterOfLike: Int, counterOfComments: Int) {
        self.newsAuthorFullName = author.fullName
        self.newsAuthorAvatarView = UIImage(named: "profileDefault") ?? UIImage(named: "profileDefault")!
        self.newsDate = date
        self.newsLabel = news
        self.newImage = image
        self.counterOfSeen = counterOfSeen
        self.counterOfLike = counterOfLike
        self.counterOfComments = counterOfComments
    }
    
}
