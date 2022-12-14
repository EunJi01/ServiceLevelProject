//
//  UserDefaults.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/11.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "showOnboarding", defaultValue: true)
    static var showOnboarding: Bool
    
    @UserDefault(key: "authenticationCompleted", defaultValue: false)
    static var authenticationCompleted: Bool
    
    @UserDefault(key: "fcmToken", defaultValue: "")
    static var fcmToken: String
    
    @UserDefault(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDefault(key: "idToken", defaultValue: "")
    static var idToken: String
    
    @UserDefault(key: "userPhoneNumber", defaultValue: "")
    static var userPhoneNumber: String
    
    @UserDefault(key: "userNickname", defaultValue: "")
    static var userNickname: String
    
    @UserDefault(key: "userBirth", defaultValue: nil)
    static var userBirth: Date?
    
    @UserDefault(key: "userEmail", defaultValue: "")
    static var userEmail: String
    
    @UserDefault(key: "userGender", defaultValue: 10)
    static var userGender: Int
    
    @UserDefault(key: "sesacNumber", defaultValue: 1)
    static var sesacNumber: Int
    
    @UserDefault(key: "uid", defaultValue: "")
    static var uid: String
}
