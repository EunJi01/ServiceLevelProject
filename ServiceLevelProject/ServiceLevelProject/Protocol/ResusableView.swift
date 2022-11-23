//
//  ResusableView.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: ReusableView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
