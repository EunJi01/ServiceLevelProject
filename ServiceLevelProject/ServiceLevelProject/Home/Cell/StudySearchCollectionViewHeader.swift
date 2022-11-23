//
//  StudySearchCollectionViewHeader.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/23.
//

import UIKit

class StudySearchCollectionViewHeader: UICollectionReusableView, CustomView {
    lazy var studyLabel: UILabel = customTitleLabel(size: 12, text: "Test", aligment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        studyLabel.backgroundColor = .yellow
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        addSubview(studyLabel)
    }
    
    private func setConstraints() {
        studyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}



