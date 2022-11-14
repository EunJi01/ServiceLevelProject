//
//  Firebase.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/11.
//

import Foundation
import FirebaseAuth

final class FirebaseAuth {
    static let shared = FirebaseAuth()
    private init() { }
    
    func requestVerificationID(number: String, completion: @escaping (String?, Error?) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+82\(number)", uiDelegate: nil) { verificationID, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(verificationID, nil)
                }
            }
    }
    
    func credential(verificationID: String, number: String) -> PhoneAuthCredential {
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: number
        )
        return credential
    }
    
    func login(credential: PhoneAuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(authResult, nil)
            }
        }
    }
    
    func getIDToken(completion: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let idToken = idToken {
                UserDefaults.idToken = idToken
                completion(error)
            } else {
                completion(error)
            }
        }
    }
}
