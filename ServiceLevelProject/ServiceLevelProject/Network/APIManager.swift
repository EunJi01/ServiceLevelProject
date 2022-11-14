//
//  APIManager.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/11.
//

import Foundation
import Alamofire

final class APIManager {
    static let shared = APIManager()
    private init() { }
    
    func get<T: Decodable>(type: T.Type, endpoint: Endpoint, completion: @escaping (APIStatusCode) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .get, headers: api.headers)
            .responseDecodable(of: T.self) { response in
                
            guard let statusCode = response.response?.statusCode else { return }
            guard let apiStatucCode = APIStatusCode(rawValue: statusCode) else { return }
            
            completion(apiStatucCode)
        }
    }
    
    func post(endpoint: Endpoint, completion: @escaping (APIStatusCode) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .post, parameters: api.parameters, headers: api.headers).response { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            guard let apiStatucCode = APIStatusCode(rawValue: statusCode) else { return }
            
            completion(apiStatucCode)
        }
    }
}
