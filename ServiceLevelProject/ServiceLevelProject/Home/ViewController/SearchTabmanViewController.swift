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

class SearchTabmanViewController: TabmanViewController {
    var center: CLLocationCoordinate2D?
    
    private let nearbyVC = NearbyViewController()
    private let requestReceivedVC = RequestReceivedViewController()
    private lazy var viewControllers = [nearbyVC, requestReceivedVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        setTabMan()
        
        let backButton = UIBarButtonItem(image: IconSet.backButton, style: .plain, target: self, action: #selector(backButtonTapped))
        let stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = stopButton
        
        guard let center = center else { return }
        nearbyVC.vm.center = center
        requestReceivedVC.vm.center = center
        nearbyVC.vm.searchSesac(center: center)
        requestReceivedVC.vm.result = nearbyVC.vm.result
    }
    
    private func setTabMan() {
        let bar = TMBar.ButtonBar()
        
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        
        bar.indicator.weight = .light
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .setColor(.green)
        
        bar.backgroundView.style = .clear
        bar.buttons.customize{ button in
            button.selectedTintColor = .setColor(.green)
            button.font = .systemFont(ofSize: 14)
        }
        
        addBar(bar, dataSource: self, at: .top)
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

extension SearchTabmanViewController: PageboyViewControllerDataSource, TMBarDataSource {
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
            return TMBarItem(title: "주변 새싹")
        case 1:
            return TMBarItem(title: "받은 요청")
        default:
            return TMBarItem(title: "Page \(index)")
        }
    }
}
