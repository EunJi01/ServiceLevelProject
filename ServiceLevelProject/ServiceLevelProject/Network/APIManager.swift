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
    
    func get<T: Decodable>(type: T.Type, endpoint: Endpoint, completion: @escaping (Result<T, APIStatusCode>) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .get, headers: api.headers)
            .responseDecodable(of: T.self) { response in
        
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIStatusCode(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
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
    
    func put(endpoint: Endpoint, completion: @escaping (APIStatusCode) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .put, parameters: api.parameters, headers: api.headers).response { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            guard let apiStatucCode = APIStatusCode(rawValue: statusCode) else { return }
            
            completion(apiStatucCode)
        }
    }
    
    func delete(endpoint: Endpoint, completion: @escaping (APIStatusCode) -> Void) {
        let api = endpoint
        guard let url = api.url else { return }
        
        AF.request(url, method: .delete, parameters: api.parameters, headers: api.headers).response { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            guard let apiStatucCode = APIStatusCode(rawValue: statusCode) else { return }
            
            completion(apiStatucCode)
        }
    }
}
