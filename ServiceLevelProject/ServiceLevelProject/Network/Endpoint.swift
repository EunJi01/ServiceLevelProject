//
//  Endpoint.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import Foundation
import Alamofire

enum Endpoint {
    case login
    case signup
}

extension Endpoint {
    static let baseURL = "http://api.sesac.co.kr:1207"
    
    var url: URL? {
        switch self {
        case .login:
            return URL(string: Endpoint.baseURL + "/v1/user")
        case .signup:
            return URL(string: Endpoint.baseURL + "/v1/user")
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login:
            return ["idtoken": UserDefaults.idToken]
        case .signup:
            let header: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded",
                "idtoken": UserDefaults.idToken
            ]
            return header
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case .login:
            return [:]
        case .signup:
            guard let birth = UserDefaults.userBirth else { return [:] }
            return [
                "phoneNumber": "+82\(UserDefaults.userPhoneNumber)",
                "FCMtoken": UserDefaults.fcmToken,
                "nick": UserDefaults.userNickname,
                "birth": "\(birth)",
                "email": UserDefaults.userEmail,
                "gender": "\(UserDefaults.userGender)"
            ]
        }
    }
}
