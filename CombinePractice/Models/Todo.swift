//
//  Todo.swift
//  CombinePractice
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation

struct Todo: Codable {
    let userID: Int
    let id: Int
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
