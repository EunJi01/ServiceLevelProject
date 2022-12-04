//
//  Chat.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/01.
//

import Foundation

struct ChatList: Codable {
    let payload: [Chat]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payload = (try? container.decode([Chat].self, forKey: .payload)) ?? []
    }
}

struct Chat: Codable {
    //let id: String
    let to, from: String
    let chat, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        //case id = "_id"
        case to, from
        case chat, createdAt
    }
}
