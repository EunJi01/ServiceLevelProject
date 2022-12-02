//
//  SearchTabmanViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/27.
//

import UIKit
import Tabman
import Pageboy
import CoreLocation

final class SearchTabViewController: TabmanViewController {
    var center: CLLocationCoordinate2D?
    
    private let nearbyVC = NearbyViewController()
    private let requestReceivedVC = RequestReceivedViewController()
    private lazy var viewControllers = [nearbyVC, requestReceivedVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        addBar(setTabMan, dataSource: self, at: .top)
        
        let backButton = UIBarButtonItem(image: IconSet.backButton, style: .done, target: self, action: #selector(backButtonTapped))
        let stopButton = UIBarButtonItem(title: "찾기중단", style: .done, target: self, action: #selector(stopButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopButton
        navigationItem.title = "새싹 찾기"
        
        guard let center = center else { return }
        nearbyVC.vm.center = center
        requestReceivedVC.vm.center = center
        nearbyVC.vm.searchSesac(center: center)
        requestReceivedVC.vm.result = nearbyVC.vm.result
    }
    
    @objc private func backButtonTapped() {
        print("backButtonTapped")
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func stopButtonTapped() {
        print("stopButtonTapped")
        nearbyVC.vm.cancelMatching()
        navigationController?.popToRootViewController(animated: true)
    }
}

extension SearchTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            return TMBarItem(title: "Page \(index)")
        }
    }
}
