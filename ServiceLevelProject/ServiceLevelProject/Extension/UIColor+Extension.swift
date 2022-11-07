//
//  UIColor+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import UIKit

extension UIColor {
    static func setColor(_ color: ColorSet) -> UIColor {
        guard let color = UIColor(named: color.rawValue) else { return UIColor() }
        return color
    }
}
