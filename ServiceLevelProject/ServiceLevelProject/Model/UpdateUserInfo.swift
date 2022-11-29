//
//  UpdateUserInfo.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/16.
//

import Foundation

struct UpdateUserInfo: Codable {
    let nick: String
    let background: Int
    let sesac: Int
    
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var study: String
}
