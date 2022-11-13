//
//  APIManager.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/11.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() { }
    
    func get<T: Decodable>(type: T.Type, endpoint: Endpoint, completion: @escaping (APIStatucCode) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .get, headers: api.headers)
            .responseDecodable(of: T.self) { response in
                
            guard let statusCode = response.response?.statusCode else { return }
            guard let apiStatucCode = APIStatucCode(rawValue: statusCode) else { return }
            
            completion(apiStatucCode)
        }
    }
    
    func post(endpoint: Endpoint, completion: @escaping (APIStatucCode) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .post, parameters: api.parameters, headers: api.headers).response { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            guard let apiStatucCode = APIStatucCode(rawValue: statusCode) else { return }
            
            completion(apiStatucCode)
        }
    }
}
