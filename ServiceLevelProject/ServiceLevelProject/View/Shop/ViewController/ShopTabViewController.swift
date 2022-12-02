//
//  ShopTabViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/02.
//

import UIKit
import Tabman
import Pageboy

final class ShopTabViewController: TabmanViewController {

    private let sesacVC = SesacShopViewController()
    private let backgroundVC = BackgroundShopViewController()
    private lazy var viewControllers = [sesacVC, backgroundVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        addBar(setTabMan, dataSource: self, at: .top)
    }
}

extension ShopTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "새싹")
        case 1:
            return TMBarItem(title: "배경")
        default:
            return TMBarItem(title: "Page \(index)")
        }
    }
}
