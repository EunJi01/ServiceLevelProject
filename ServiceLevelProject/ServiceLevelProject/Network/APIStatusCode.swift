//
//  APIError.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import Foundation

enum APIStatusCode: Int, Error {
    case success = 200
    case error201
    case error202
    case error203
    case error204
    case error205
    
    case firebaseTokenError = 401
    case notRegistered = 406
    case serverError = 500
    case clientError = 501
}

extension APIStatusCode: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .firebaseTokenError:
            return "Firebase 토큰 에러가 발생했습니다."
        case .notRegistered:
            return "미가입 회원입니다."
        case .serverError:
            return "서버 에러가 발생했습니다."
        case .clientError:
            return "클라이언트 에러가 발생했습니다."
        default:
            return "errer\(rawValue)"
        }
    }
}
