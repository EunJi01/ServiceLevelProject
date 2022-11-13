//
//  APIError.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import Foundation

enum APIStatusCode: Int, Error {
    case success = 200
    case alreadySigned = 201
    case nicknameError = 202
    case firebaseTokenError = 401
    case mustSignup = 406
    case serverError = 500
    case clientError = 501
}

extension APIStatusCode: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .alreadySigned:
            return "이미 가입된 회원입니다."
        case .nicknameError:
            return "사용할 수 없는 닉네임입니다."
        case .firebaseTokenError:
            return "Firebase 토큰 에러가 발생했습니다."
        case .serverError:
            return "서버에 에러가 발생했습니다."
        case .clientError:
            return "클라이언트 에러가 발생했습니다."
        default:
            return nil
        }
    }
}
