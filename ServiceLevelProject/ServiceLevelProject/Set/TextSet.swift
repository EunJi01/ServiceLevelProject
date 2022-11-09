//
//  TextSet.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import Foundation

enum TextSet: String {
    // MARK: Onboarding
    case onboardingText1 = "위치 기반으로 빠르게\n주위 친구를 확인"
    case onboardingText2 = "스터디를 원하는 친구를\n찾을 수 있어요"
    case onboardingText3 = "SeSAC Study"
    
    // MARK: Login
    case login = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
    case login2 = "인증번호가 문자로 전송되었어요"
    
    // MARK: Signup
    case nickname = "닉네임을 입력해 주세요"
    case birth = "생년월일을 알려주세요"
    case email = "이메일을 입력해 주세요"
    case emailSub = "휴대폰 번호 변경 시 인증을 위해 사용해요"
    case gender = "성별을 선택해 주세요"
    case genderSub = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
}
