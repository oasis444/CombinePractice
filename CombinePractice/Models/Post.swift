//
//  Post.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation

struct Post: Codable {
    let userID: Int
    let id: Int
    let title: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
