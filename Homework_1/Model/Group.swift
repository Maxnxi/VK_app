//
//  Group.swift
//  Homework_1
//
//  Created by Maksim on 24.02.2021.
//

import Foundation

let globGroups:[Group] = Group.loadData()

class Group {
    
    var name: String?
    
    init(name: String){
        self.name = name
    }
    
    
}

extension Group {
    
    static let group1 = Group(name: "Отечественное кино")
    static let group2 = Group(name: "Swift для чайников")
    static let group3 = Group(name: "Swift для реальных пацанов, Колян едишн")
    static let group4 = Group(name: "Yandex")
    static let group5 = Group(name: "Mail")
    static let group6 = Group(name: "Geekbrains")
    static let group7 = Group(name: "Google")
    
    static func loadData() -> [Group] {
        return [.group1,.group2,.group3,.group4,.group5,.group6,.group7]
    }
}
