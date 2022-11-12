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
    
    func signup(completion: @escaping (Bool) -> Void) {
        let api = Endpoint.signup
        
        AF.request(api.url, method: .post, parameters: api.parameters, headers: api.headers).responseString { response in
            print(response)
            print((response.response?.statusCode)!)
            
            switch response.result {
            case .success(_):
                print("회원가입 성공")
                completion(true)
            case .failure(_):
                print("회원가입 실패")
                completion(false)
            }
        }
    }
}
