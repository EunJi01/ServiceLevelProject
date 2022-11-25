//
//  MainTabBarController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import UIKit

enum mainTabBar: CaseIterable {
    case home
    case shop
    case mypage
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .shop:
            return "새싹샵"
        case .mypage:
            return "내정보"
        }
    }
    
    var tabBarIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")
        case .shop:
            return UIImage(systemName: "gift")
        case .mypage:
            return UIImage(systemName: "person")
        }
    }
    
    var viewcontroller: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .shop:
            return HomeViewController()
        case .mypage:
            return MypageViewController()
        }
    }
}

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        var tabBarVC: [UIViewController] = []
        
        mainTabBar.allCases.forEach {
            let nav = UINavigationController(rootViewController: $0.viewcontroller)
            nav.tabBarItem = UITabBarItem(title: $0.title, image: $0.tabBarIcon, selectedImage: $0.tabBarIcon)
            tabBarVC.append(nav)
        }

        setViewControllers(tabBarVC, animated: true)
        hidesBottomBarWhenPushed = true // 네비게이션VC로 푸쉬했을 때 밑에 바가 사라지는 것
        tabBar.tintColor = .setColor(.green)
    }
}
