//
//  UserState.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/29.
//

import Foundation

struct State: Codable {
    let dodged, matched, reviewed: Int
    let matchedNick, matchedUid: String?
}
