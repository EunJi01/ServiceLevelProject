//
//  CustomView.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import UIKit

protocol CustomView {
    func customButton(title: String) -> UIButton
    func customTitleLabel(size: CGFloat,text: String, aligment: NSTextAlignment, lineBreakMode: NSLineBreakMode) -> UILabel
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
    
    func customTitleLabel(size: CGFloat ,text: String, aligment: NSTextAlignment = .center, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = aligment
        view.lineBreakMode = lineBreakMode
        view.font = .systemFont(ofSize: size)
        view.text = text
        return view
    }
    
    func customUnderlineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .setColor(.gray3)
        return view
    }
    
    func customTextField(placeholder: String, keyboard: UIKeyboardType = .default) -> UITextField {
        let view = UITextField()
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.setColor(.gray7)]
        view.font = .systemFont(ofSize: 14)
        view.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        return view
    }
}
