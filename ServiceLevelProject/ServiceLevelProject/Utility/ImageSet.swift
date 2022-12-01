//
//  ImageSet.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit

enum ImageSet: String {
    // LaunchScreen
    case splashLogo = "splash_logo"
    case splashTitle = "splash_title"
    
    // Onboarding
    case onboardingImg1 = "onboarding_img1"
    case onboardingImg2 = "onboarding_img2"
    case onboardingImg3 = "onboarding_img3"
    
    // Button
    case man
    case woman
    case gps
    case send
    case sendFill = "send.fill"
    
    // 그 외
    case mapMarker = "map_marker"
    case sesacNodata = "sesac_nodata"
}

struct IconSet {
    static let backButton = UIImage(systemName: "arrow.left")
    static let chevronDown = UIImage(systemName: "chevron.down")
    static let search = UIImage(systemName: "magnifyingglass")
    static let explore = UIImage(systemName: "antenna.radiowaves.left.and.right")
    static let massage = UIImage(systemName: "envelope")
    static let refresh = UIImage(systemName: "arrow.clockwise")
}

enum SeSACFace: Int {
    case sesacFace1
    case sesacFace2
    case sesacFace3
    case sesacFace4
    case sesacFace5
    
    var image: UIImage? {
        return UIImage(named: "sesac_face_\(rawValue + 1)")
    }
}

enum SeSACBackground: Int {
    case sesacBackground1
    case sesacBackground2
    case sesacBackground3
    case sesacBackground4
    case sesacBackground5
    case sesacBackground6
    case sesacBackground7
    case sesacBackground8
    case sesacBackground9
    
    var image: UIImage? {
        return UIImage(named: "sesac_background_\(rawValue + 1)")
    }
}
