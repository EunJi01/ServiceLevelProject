//
//  UIImage+Extension.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit

extension UIImage {
    static func setImage(_ image: ImageSet) -> UIImage {
        guard let image = UIImage(named: image.rawValue) else { return UIImage() }
        return image
    }
}
