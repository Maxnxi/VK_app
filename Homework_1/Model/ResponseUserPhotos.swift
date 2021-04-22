//
//  Photo.swift
//  Homework_1
//
//  Created by Maksim on 21.04.2021.
//
import Foundation

struct ResponseUserPhotos: Codable {
    let response: ResponsePhotosInfo
}

struct ResponsePhotosInfo: Codable {
    let count: Int
    let items: [UserPhoto]
}

struct UserPhoto: Codable {
    let albumID, date, id, ownerID: Int
        let hasTags: Bool
        //let postID: Int?
        let sizes: [Size]
        let text: String
        let likes: Likes
        let reposts: Reposts

        enum CodingKeys: String, CodingKey {
            case albumID = "album_id"
            case date, id
            case ownerID = "owner_id"
            case hasTags = "has_tags"
            //case postID = "post_id"
            case sizes, text, likes, reposts
        }
}

// MARK: - Likes
struct Likes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    let count: Int
}

// MARK: - Size
struct Size: Codable {
    let height: Int
    let url: String
    let type: String
    let width: Int
}
