//
//  Group.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//
//    "response": {
//    "count": 60,
//    "items": [{
//    "id": 45688121,
//    "name": "ЭТО ФАКТ | Наука и Факты",
//    "screen_name": "fakt8",
//    "is_closed": 0,
//    "type": "page",
//    "is_admin": 0,
//    "is_member": 1,
//    "is_advertiser": 0,
//    "photo_50": "https://sun1-98.u...1000,1000&ava=1",
//    "photo_100": "https://sun1-98.u...1000,1000&ava=1",
//    "photo_200": "https://sun1-98.u...1000,1000&ava=1"

import Foundation
import UIKit

//let globGroups:[Group] = Group.loadData()


//struct GroupS: Codable {
//    let id: Int
//    let name: String
//    let image: UIImage
//}

class Group {
    
    var name: String?
    var photo: UIImage?
    var id: Int?


    
    init(id: Int, name: String, photo: UIImage){
        self.id = id
        self.name = name
        self.photo = photo
    }
    
    
}

extension Group {
    
//    static let group1 = Group(name: "Отечественное кино")
//    static let group2 = Group(name: "Swift для чайников")
//    static let group3 = Group(name: "Swift для реальных пацанов, Колян едишн")
//    static let group4 = Group(name: "Yandex")
//    static let group5 = Group(name: "Mail")
//    static let group6 = Group(name: "Geekbrains")
//    static let group7 = Group(name: "Google")
//
//    static func loadData() -> [Group] {
//        return [.group1,.group2,.group3,.group4,.group5,.group6,.group7]
//    }
    
}
