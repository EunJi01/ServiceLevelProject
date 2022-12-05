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
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: button, style: .default, handler: buttonAction)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    func networkCheck(completion: @escaping (Bool) -> Void) {
        if NetworkCheck.shared.isConnected {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.frame.origin.y -= keyboardHeight
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1) {
                self.view.frame.origin.y += keyboardHeight
            }
        }
    }
}
