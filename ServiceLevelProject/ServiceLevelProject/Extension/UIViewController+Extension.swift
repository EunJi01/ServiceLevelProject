//
//  UIViewController+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/13.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: buttonAction)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
