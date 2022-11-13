//
//  MainTabBarController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import UIKit

enum TabBarTitle: String {
    case home = "홈"
    case shop = "새싹샵"
    case friend = "새싹친구"
    case myInfo = "내정보"
}

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        let firstNav = UINavigationController(rootViewController: MyInfoViewController())
        let secondNav = UINavigationController(rootViewController: MyInfoViewController())
        let thirdNav = UINavigationController(rootViewController: MyInfoViewController())
        let fourthNav = UINavigationController(rootViewController: MyInfoViewController())

        firstNav.tabBarItem = UITabBarItem(title: TabBarTitle.home.rawValue, image: .setImage(.woman), tag: 0)
        secondNav.tabBarItem = UITabBarItem(title: TabBarTitle.shop.rawValue, image: .setImage(.woman), tag: 1)
        thirdNav.tabBarItem = UITabBarItem(title: TabBarTitle.friend.rawValue, image: .setImage(.woman), tag: 2)
        fourthNav.tabBarItem = UITabBarItem(title: TabBarTitle.myInfo.rawValue, image: .setImage(.woman), tag: 3)

        setViewControllers([firstNav, secondNav, thirdNav, fourthNav], animated: true)
        hidesBottomBarWhenPushed = true // 네비게이션VC로 푸쉬했을 때 밑에 바가 사라지는 것
        tabBar.tintColor = .setColor(.green)
    }
}
