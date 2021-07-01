//
//  PhotoModel.swift
//  Homework_1
//
//  Created by Maksim on 30.06.2021.
//

import Foundation
import SwiftyJSON

protocol ImageNodeRepresentable {
    var url: URL { get }
    var aspectRatio: CGFloat { get }
}

class PhotoModel: ImageNodeRepresentable {
    let id: Int?
    let date: Date?
    let width: Int
    let height: Int
    var url: URL
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width)}
    
    
    init?(object: UserPhoto){
        self.id = object.id
        self.date = Date(timeIntervalSince1970: TimeInterval(object.date ))
        guard let xSize = object.sizes.first(where: {$0.type == "x"}),
              let url = URL(string: xSize.url) else { return nil }
        self.width = xSize.width
        self.height = xSize.height
        self.url = url
    }
}


