//
//  Chat.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/01.
//

import Foundation

struct ChatList: Codable {
    let payload: [Chat]
}

struct Chat: Codable {
    let to, from: String
    let chat, createdAt: String
}
