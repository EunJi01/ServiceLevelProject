//
//  Mypage.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit

enum Mypage: CaseIterable {
    case notify
    case faq
    case inquiry
    case notification
    case termsAndConditions
    
    var title: String {
        switch self {
        case .notify:
            return "공지사항"
        case .faq:
            return "자주 묻는 질문"
        case .inquiry:
            return "1:1 문의"
        case .notification:
            return "알림 설정"
        case .termsAndConditions:
            return "이용약관"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .notify:
            return UIImage(systemName: "megaphone")
        case .faq:
            return UIImage(systemName: "questionmark.circle")
        case .inquiry:
            return UIImage(systemName: "ellipsis.bubble")
        case .notification:
            return UIImage(systemName: "bell")
        case .termsAndConditions:
            return UIImage(systemName: "wallet.pass")
        }
    }
}
