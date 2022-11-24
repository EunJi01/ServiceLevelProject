//
//  StudySearchViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/22.
//

import UIKit

final class StudySearchCollectionViewCell: UICollectionViewCell {
    let borderView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.setColor(.gray3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let studyLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        addSubview(borderView)
        borderView.addSubview(studyLabel)
    }
    
    private func setConstraints() {
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        studyLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
}
