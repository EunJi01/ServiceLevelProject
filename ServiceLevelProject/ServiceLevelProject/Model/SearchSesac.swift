//
//  SearchSesac.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/18.
//

import Foundation

struct SearchSesac: Codable {
    let fromQueueDB: [FromQueueDB]
    let fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

struct FromQueueDB: Codable {
    let studylist, reviews: [String]
    let reputation: [Int]
    let uid, nick: String
    let gender, type, sesac, background: Int
    let long, lat: Double
}
