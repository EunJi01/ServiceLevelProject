//
//  StudyListLayout.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/23.
//

import UIKit

final class StudyListLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.sectionInset = UIEdgeInsets(top: 8, left: .zero, bottom: .zero, right: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let cellSpacing: CGFloat = 8
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}
