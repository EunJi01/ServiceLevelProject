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
    
    // MARK: 바버튼아이템 unrecognized selector sent to class 에러
//    private let backButton = UIBarButtonItem(image: IconSet.backButton, style: .plain, target: SearchTabmanViewController.self, action: #selector(backButtonTapped))
//    private let stopButton = UIBarButtonItem(title: "찾기중단", style: .plain, target: SearchTabmanViewController.self, action: #selector(stopButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
//        navigationItem.leftBarButtonItem = backButton
//        navigationItem.rightBarButtonItem = stopButton
        
        setTabMan()
        
        guard let center = center else { return }
        searchSesac(center:center)
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
    
    private func searchSesac(center: CLLocationCoordinate2D) {
        APIManager.shared.sesac(type: SearchSesac.self, endpoint: .queueSearch(lat: center.latitude, long: center.longitude)) { [weak self] response in
            switch response {
            case .success(let sesac):
                self?.nearbyVC.vm.result = sesac
                self?.requestReceivedVC.vm.result = sesac
                self?.nearbyVC.vm.refreshRelay.accept(())
                self?.requestReceivedVC.vm.refreshRelay.accept(())
                
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.searchSesac(center: center)
                        } else {
                            self?.view.makeToast(statusCode.errorDescription, position: .top)
                        }
                    }
                default:
                    self?.view.makeToast(statusCode.errorDescription, position: .top)
                }
            }
        }
    }
    
//    @objc private func backButtonTapped() {
//        print("backButtonTapped")
////        let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 4]
////        self.navigationController?.popToViewController(controller!, animated: true)
//    }
//
//    @objc private func stopButtonTapped() {
//        print("stopButtonTapped")
////        nearbyVC.vm.cancelMatching()
//    }
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
