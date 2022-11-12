//
//  Endpoint.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import Foundation
import Alamofire

enum Endpoint {
    case signup
}

extension Endpoint {
    static let base = "http://api.sesac.co.kr:1207"
    
    var url: URL {
        switch self {
        case .signup:
            return URL(string: Endpoint.base + "/v1/user")! // MARK: 옵셔널 해제 어케하징...
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
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
            
        case .signup:
            guard let birth = UserDefaults.userBirth else { return [:] }
            
            return [
                "phoneNumber": UserDefaults.userPhoneNumber,
                "FCMtoken": "",
                "nick": UserDefaults.userNickname,
                "birth": "\(birth)",
                "email": UserDefaults.userEmail,
                "gender": "\(UserDefaults.userGender)"
            ]
        }
    }
}
