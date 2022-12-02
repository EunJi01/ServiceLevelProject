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

    private var cardView = CardView()
    
    private let sesacVC = SesacShopViewController()
    private let backgroundVC = BackgroundShopViewController()
    private lazy var viewControllers = [sesacVC, backgroundVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: 네비게이션 바가 투명하다...! 다른곳도 확인해보고 수정하기
        navigationItem.title = "새싹샵"
        
        dataSource = self
        
        cardView.nicknameView.isHidden = true
        addBar(setTabMan, dataSource: self, at: .top)
//        addBar(setTabMan, dataSource: self, at: .custom(view: cardView) { [weak self] view in
//            view.snp.makeConstraints { [weak self] make in
//                guard let self = self else { return }
//                make.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
//                make.height.equalTo(self.cardView.width).multipliedBy(0.5)
//            }
//        })
    }
}

extension ShopTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
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
