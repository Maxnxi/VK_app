//
//  PhotoAlbumItem.swift
//  Homework_1
//
//  Created by Maksim on 03.07.2021.
//

import Foundation

// MARK: - Welcome
struct WelcomePhotoAlbum: Codable {
    let response: ResponsePhotoAlbumItem
}

// MARK: - Response
struct ResponsePhotoAlbumItem: Codable {
    let count: Int
    let items: [PhotoAlbumModel]
}

// MARK: - PhotoAlbumModel
struct PhotoAlbumModel: Codable {
    let id, thumbID, ownerID: Int
    let title, itemDescription: String
    let created, updated, size, thumbIsLast: Int
    let thumbSrc: String

    enum CodingKeys: String, CodingKey {
        case id
        case thumbID = "thumb_id"
        case ownerID = "owner_id"
        case title
        case itemDescription = "description"
        case created, updated, size
        case thumbIsLast = "thumb_is_last"
        case thumbSrc = "thumb_src"
    }
}
