//
//  ChatDBRepository.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/04.
//

import Foundation
import RealmSwift

protocol ChatDBRepositoryType {
    func fetch(uid: String) -> [Chat]
    func addChat(chatList: [Chat])
}

class ChatDBRepository: ChatDBRepositoryType {
    let localRealm = try! Realm()
    
    func fetch(uid: String) -> [Chat] {
        let results = localRealm.objects(ChatDB.self).filter("to == '\(uid)' OR from == '\(uid)'").sorted(byKeyPath: "createdAt", ascending: true)
        var chatList: [Chat] = []
        
        results.forEach {
            let chat = Chat(to: $0.to, from: $0.from, chat: $0.chat, createdAt: $0.createdAt)
            chatList.append(chat)
        }
        
        return chatList
    }
    
    func addChat(chatList: [Chat]) {
        chatList.forEach {
            let chat = ChatDB(to: $0.to, from: $0.from, chat: $0.chat, createdAt: $0.createdAt.toDate.toString)
            
            do {
                try localRealm.write {
                    localRealm.add(chat)
                }
            } catch {
                print(error)
            }
        }
    }
}
