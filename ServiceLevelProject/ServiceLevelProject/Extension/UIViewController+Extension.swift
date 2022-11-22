//
//  UIViewController+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/13.
//

import UIKit

extension UIViewController {
    enum TransitionStyle {
        case present // 그냥 Present
        case presentNavigation // 네비게이션 임베드 Present
        case presentFullNavigation // 네비게이션 풀스크린
        case presentOverFull // 팝업용
        case push
        case presentFull
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle) {
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated: true)
        case .push:
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case .presentFullNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .presentOverFull:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        case .presentFull:
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
    }
    
    func showAlert(title: String, message: String?, button: String = "확인", buttonAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default, handler: buttonAction)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func networkCheck(completion: @escaping (Bool) -> Void) {
        if NetworkCheck.shared.isConnected {
            completion(true)
        } else {
            showAlert(title: "네트워크 연결이 원할하지 않습니다.", message: "연결상태 확인 후 다시 시도해주세요!") { _ in }
            completion(false)
        }
    }
}
