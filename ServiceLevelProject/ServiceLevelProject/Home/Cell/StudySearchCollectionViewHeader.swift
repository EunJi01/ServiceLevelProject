//
//  StudySearchCollectionViewHeader.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/23.
//

import UIKit

final class StudySearchCollectionViewHeader: UICollectionReusableView, CustomView {
    lazy var studyLabel: UILabel = customTitleLabel(size: 12, text: "", aligment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(studyLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        studyLabel.frame = bounds
    }
}
