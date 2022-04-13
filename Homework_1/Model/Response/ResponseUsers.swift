//
//  User.swift
//  Homework_1
//
//  Created by Maksim on 25.02.2021.
//


import Foundation

struct ResponseUsers: Codable {
    let response: ResponseUsersInfo
}

struct ResponseUsersInfo: Codable {
    let count: Int
    let items: [User]
}

struct User: Codable {
    let firstName: String
    let id: Int
    let lastName: String
    let canAccessClosed, isClosed: Bool?
    let photo: String
    let trackCode: String
    let deactivated: String?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case id
        case lastName = "last_name"
        case canAccessClosed = "can_access_closed"
        case isClosed = "is_closed"
        case photo
        case trackCode = "track_code"
        case deactivated
    }
}
