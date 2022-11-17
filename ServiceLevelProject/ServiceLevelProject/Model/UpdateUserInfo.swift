//
//  UpdateUserInfo.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/16.
//

import Foundation

struct UpdateUserInfo: Codable {
    let nick: String
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    let study: String
    let background: Int
    let sesac: Int
}
