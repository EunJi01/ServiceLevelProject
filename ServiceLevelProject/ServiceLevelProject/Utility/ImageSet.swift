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
    
    // 그 외
    case mapMarker = "map_marker"
}

struct IconSet {
    static let backButton = UIImage(systemName: "arrow.left")
    static let chevronDown = UIImage(systemName: "chevron.down")
    static let search = UIImage(systemName: "magnifyingglass")
    static let explore = UIImage(systemName: "antenna.radiowaves.left.and.right")
    static let massage = UIImage(systemName: "envelope")
}

enum SeSACFace: Int {
    case sesacFace1 = 0
    case sesacFace2 = 1
    case sesacFace3 = 2
    case sesacFace4 = 3
    case sesacFace5 = 4
    
    var image: UIImage? {
        switch self {
        case .sesacFace1:
            return UIImage(named: "sesac_face_1")
        case .sesacFace2:
            return UIImage(named: "sesac_face_2")
        case .sesacFace3:
            return UIImage(named: "sesac_face_3")
        case .sesacFace4:
            return UIImage(named: "sesac_face_4")
        case .sesacFace5:
            return UIImage(named: "sesac_face_5")
        }
    }
}

enum SeSACBackground: Int {
    case sesacBackground1 = 0
    case sesacBackground2 = 1
    case sesacBackground3 = 2
    case sesacBackground4 = 3
    case sesacBackground5 = 4
    case sesacBackground6 = 5
    case sesacBackground7 = 6
    case sesacBackground8 = 7
    case sesacBackground9 = 8
    
    var image: UIImage? {
        switch self {
        case .sesacBackground1:
            return UIImage(named: "sesac_background_1")
        case .sesacBackground2:
            return UIImage(named: "sesac_background_2")
        case .sesacBackground3:
            return UIImage(named: "sesac_background_3")
        case .sesacBackground4:
            return UIImage(named: "sesac_background_4")
        case .sesacBackground5:
            return UIImage(named: "sesac_background_5")
        case .sesacBackground6:
            return UIImage(named: "sesac_background_6")
        case .sesacBackground7:
            return UIImage(named: "sesac_background_7")
        case .sesacBackground8:
            return UIImage(named: "sesac_background_8")
        case .sesacBackground9:
            return UIImage(named: "sesac_background_9")
        }
    }
}
