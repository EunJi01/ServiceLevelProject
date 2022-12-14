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
    
    func sesac<T: Decodable>(type: T.Type = String.self, endpoint: Endpoint, completion: @escaping (Result<T, APIStatusCode>) -> Void) {
        guard let url = endpoint.url else { return }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.parameters, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: endpoint.headers)
            .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                    print("APIManager - 성공!")
                    
                case .failure(let error):
                    print("========")
                    print(error)
                    guard let statusCode = response.response?.statusCode else { return }
                    guard let error = APIStatusCode(rawValue: statusCode) else { return }
                    
                    if statusCode == 200 && type == String.self {
                        completion(.success("" as! T))
                        print("APIManager - 성공!")
                    } else {
                        completion(.failure(error))
                        print("APIManager - \(statusCode)")
                    }
                }
            }
    }
}
