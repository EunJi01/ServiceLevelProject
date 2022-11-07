//
//  UILabel+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit

extension UILabel {
    func asColor(targetString: String, color: ColorSet) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        guard let color = UIColor(named: color.rawValue) else { return }
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}
