//
//  Endpoint.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import Foundation
import Alamofire
import MapKit

enum Endpoint {
    case login
    case signup
    case mypage(searchable: Int, ageMin: Int, ageMax: Int, gender: Int, study: String)
    case withdraw
    
    case queueRequest(lat: CLLocationDegrees, long: CLLocationDegrees, studyList: [String])
    case queueStop
    case queueSearch(lat: CLLocationDegrees, long: CLLocationDegrees)
    case myQueueState
    
    case studyrequest(otheruid: String)
    case studyaccept(otheruid: String)
    case dodge(otheruid: String)
    
    case postChat(to: String, chat: String)
    case fetchChat(from: String, lastChatDate: String)
}

extension Endpoint {
    static let baseURL = "http://api.sesac.co.kr:1210/"
    
    var url: URL? {
        switch self {
        case .login:
            return URL(string: Endpoint.baseURL + "v1/user")
        case .signup:
            return URL(string: Endpoint.baseURL + "v1/user")
        case .mypage:
            return URL(string: Endpoint.baseURL + "v1/user/mypage")
        case .withdraw:
            return URL(string: Endpoint.baseURL + "v1/user/withdraw")
        case .queueRequest:
            return URL(string: Endpoint.baseURL + "v1/queue")
        case .queueStop:
            return URL(string: Endpoint.baseURL + "v1/queue")
        case .queueSearch:
            return URL(string: Endpoint.baseURL + "v1/queue/search")
        case .myQueueState:
            return URL(string: Endpoint.baseURL + "v1/queue/myQueueState")
        case .studyrequest:
            return URL(string: Endpoint.baseURL + "v1/queue/studyrequest")
        case .studyaccept:
            return URL(string: Endpoint.baseURL + "v1/queue/studyaccept")
        case .dodge:
            return URL(string: Endpoint.baseURL + "v1/queue/dodge")
        case .postChat(let to, _):
            return URL(string: Endpoint.baseURL + "v1/chat/\(to)")
        case .fetchChat(let from, let lastChatDate):
            return URL(string: Endpoint.baseURL + "v1/chat/\(from)?lastchatDate=\(lastChatDate)")
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .get
        case .signup:
            return .post
        case .mypage:
            return .put
        case .withdraw:
            return .post
        case .queueRequest:
            return .post
        case .queueStop:
            return .delete
        case .queueSearch:
            return .post
        case .myQueueState:
            return .get
        case .studyrequest:
            return .post
        case .studyaccept:
            return .post
        case .dodge:
            return .post
        case .postChat:
            return .post
        case .fetchChat:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        let header: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "idtoken": UserDefaults.idToken
        ]

        return header
    }
    
    var parameters: [String: Any] {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .signup:
            parameters = [
                "phoneNumber": "+82\(UserDefaults.userPhoneNumber.dropFirst())",
                "FCMtoken": UserDefaults.fcmToken,
                "nick": UserDefaults.userNickname,
                "birth": "\(UserDefaults.userBirth!)",
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
        case .queueRequest(let lat, let long, let studyList):
            parameters = [
                "lat": "\(lat)",
                "long": "\(long)",
                "studylist": studyList
            ]
        case .queueSearch(let lat, let long):
            parameters = [
                "lat": "\(lat)",
                "long": "\(long)"
            ]
        case .studyrequest(let otheruid), .studyaccept(let otheruid), .dodge(let otheruid):
            parameters = [
                "otheruid": otheruid
            ]
        case .postChat(_, let chat):
            parameters = [
                "chat": chat
            ]
        default:
            break
        }
        
        return parameters
    }
}

