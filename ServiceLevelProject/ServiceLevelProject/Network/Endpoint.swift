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
    case mypage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String)
    case withdraw
    
    case queueRequest
    case queueStop
    case queueSearch
    case myQueueState
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
        case .queueRequest:
            return URL(string: Endpoint.baseURL + "v1/queue")
        case .queueStop:
            return URL(string: Endpoint.baseURL + "v1/queue")
        case .queueSearch:
            return URL(string: Endpoint.baseURL + "v1/queue/search")
        case .myQueueState:
            return URL(string: Endpoint.baseURL + "v1/myQueueState")
        }
    }
    
    var headers: HTTPHeaders {
        var header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.idToken
        ]
        
        switch self {
        default:
            break
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
        case .mypage(let searchable, let ageMin, let ageMax, let gender, let study):
            parameters = [
                "searchable": "\(searchable)",
                "ageMin": "\(ageMin)",
                "ageMax": "\(ageMax)",
                "gender": "\(gender)",
                "study": study
            ]
        case .queueRequest:
            parameters = [
                "lat": "",
                "long": "",
                "studylist": ""
            ]
        case .queueSearch:
            parameters = [
                "lat": "",
                "long": ""
            ]
        default:
            break
        }
        
        return parameters
    }
}

