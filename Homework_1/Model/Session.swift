//
//  Session.swift
//  Homework_1
//
//  Created by Maksim on 08.04.2021.
//

import Foundation

final class Session {
    
    static let shared = Session()
    
    var token: String?
    var userId: String?
    var authorized: Bool = false
    
    private init() {}
}
