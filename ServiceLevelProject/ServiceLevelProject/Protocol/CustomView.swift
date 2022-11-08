//
//  CustomView.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import UIKit

protocol CustomView {
    func customButton(title: String) -> UIButton
    func customTitleLabel(size: CGFloat,text: String) -> UILabel
    func customUnderlineView() -> UIView
}

extension CustomView {
    func customButton(title: String) -> UIButton {
        let view = UIButton()
        view.backgroundColor = .setColor(.gray6)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.setTitle(title, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        return view
    }
    
    func customTitleLabel(size: CGFloat ,text: String = "") -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = .systemFont(ofSize: size)
        view.text = text
        // MARK: 행간 조절하기!
        return view
    }
    
    func customUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .setColor(.gray3)
        return view
    }
    
    func customTextField(placeholder: String, keyboard: UIKeyboardType = .default) -> UITextField {
        let view = UITextField()
        view.placeholder = placeholder
        view.keyboardType = keyboard
        return view
    }
}
