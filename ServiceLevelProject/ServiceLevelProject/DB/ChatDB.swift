//
//  ChatDB.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/04.
//

import Foundation
import RealmSwift

class ChatDB: Object {
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: String
    
    convenience init(to: String, from: String, chat: String, createdAt: String) {
        self.init()
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}
