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
    case mypage
    case withdraw
}

extension Endpoint {
    static let baseURL = "http://api.sesac.co.kr:1207/"
    
    var url: URL? {
        switch self {
        case .login:
            return URL(string: Endpoint.baseURL + "v1/user")
        case .signup:
            return URL(string: Endpoint.baseURL + "v1/user")
        case .mypage:
            return URL(string: Endpoint.baseURL + "v1/user/mypage")
        case .withdraw:
            return URL(string: Endpoint.baseURL + "v1/withdraw")
        }
    }
    
    var headers: HTTPHeaders {
        var header: HTTPHeaders = [:]
        
        switch self {
        case .login:
            header = ["idtoken": UserDefaults.idToken]
        case .signup:
            header = [
                "Content-Type": "application/x-www-form-urlencoded",
                "idtoken": UserDefaults.idToken
            ]
        case .mypage:
            header = [:]
        case .withdraw:
            header = ["idtoken": UserDefaults.idToken]
        }
        
        return header
    }
    
    var parameters: [String: String] {
        var parameters: [String: String] = [:]
        
        switch self {
        case .signup:
            guard let birth = UserDefaults.userBirth else { return [:] }
            parameters = [
                "phoneNumber": "+82\(UserDefaults.userPhoneNumber.dropFirst())",
                "FCMtoken": UserDefaults.fcmToken,
                "nick": UserDefaults.userNickname,
                "birth": "\(birth)",
                "email": UserDefaults.userEmail,
                "gender": "\(UserDefaults.userGender)"
            ]
        case .mypage:
            parameters = [
                "searchable": "",
                "ageMin": "",
                "ageMax": "",
                "gender": "",
                "study": ""
            ]
        default:
            break
        }
        
        return parameters
    }
}
