//
//  UIViewController+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/13.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, buttonAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: buttonAction)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func networkCheck() -> Bool {
        if NetworkCheck.shared.isConnected {
            return true
        } else {
            showAlert(title: "네트워크 연결이 원할하지 않습니다.", message: "연결상태 확인 후 다시 시도해주세요!") { _ in }
            return false
        }
    }
}
