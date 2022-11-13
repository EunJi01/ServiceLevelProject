//
//  MainTabBarController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/12.
//

import UIKit

class MainTabBarController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        //configureTabBarController()
    }
    
//    private func configureTabBarController() {
//        let firstNav = UINavigationController(rootViewController: HomeViewController())
//        let secondNav = UINavigationController(rootViewController: RatingViewController())
//        let thirdNav = UINavigationController(rootViewController: UpcomingGameViewController())
//
//        firstNav.tabBarItem = UITabBarItem(title: LocalizationKey.newGames.localized, image: TabBarIconSet.newly, selectedImage: TabBarIconSet.newlySelected)
//        secondNav.tabBarItem = UITabBarItem(title: LocalizationKey.popularGames.localized, image: TabBarIconSet.rating, selectedImage: TabBarIconSet.ratingSelected)
//        thirdNav.tabBarItem = UITabBarItem(title: LocalizationKey.upcomingGames.localized, image: TabBarIconSet.upcoming, selectedImage: TabBarIconSet.upcomingSelected)
//
//        setViewControllers([secondNav, firstNav, thirdNav], animated: true)
//        hidesBottomBarWhenPushed = true // 네비게이션VC로 푸쉬했을 때 밑에 바가 사라지는 것
//        tabBar.tintColor = ColorSet.shared.button
//    }
}
