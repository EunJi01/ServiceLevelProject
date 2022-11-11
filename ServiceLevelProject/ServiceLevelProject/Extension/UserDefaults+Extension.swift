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
    
    @UserDefault(key: "didAuth", defaultValue: false)
    static var didAuth: Bool
    
    @UserDefault(key: "authVerificationID", defaultValue: "")
    static var authVerificationID: String
    
    @UserDefault(key: "userPhoneNumber", defaultValue: "")
    static var userPhoneNumber: String
    
    @UserDefault(key: "userNickname", defaultValue: "")
    static var userNickname: String
    
    @UserDefault(key: "userBirth", defaultValue: "")
    static var userBirth: String
    
    @UserDefault(key: "userEmail", defaultValue: "")
    static var userEmail: String
    
    @UserDefault(key: "userToken", defaultValue: "")
    static var userToken: String
}
