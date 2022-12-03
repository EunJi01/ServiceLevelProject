//
//  SocketIOManager.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/01.
//

import Foundation
import SocketIO
import Alamofire

class SocketIOManager {
    static let shared = SocketIOManager()

    var manager: SocketManager!
    var socket: SocketIOClient!

    private init() {
        manager = SocketManager(socketURL: URL(string: Endpoint.baseURL)!, config: [.forceWebsockets(true)])
        socket = manager.defaultSocket

        // 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", UserDefaults.uid)
        }

        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }

        // 이벤트 수신
        socket.on("chat") { dataArray, ack in
            let data = dataArray[0] as! NSDictionary
            let to = data["to"] as! String
            let from = data["from"] as! String
            let chat = data["chat"] as! String
            let createdAt = data["createdAt"] as! String

            print("CHECK >>>", chat, to, from)

            NotificationCenter.default.post(name: Notification.Name("getMessage"), object: self, userInfo: [
                "to": to, "from": from, "chat": chat, "createdAt": createdAt
            ])
        }
    }

    func establishConnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }
}
