//
//  MypageTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit

final class MypageTableViewCell: UITableViewCell, CustomView {
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .black
        return view
    }()
    
    lazy var titleLabel: UILabel = customTitleLabel(size: 16, text: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        [iconImageView, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(2)
            make.height.width.equalTo(20)
            make.verticalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(14)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
    }
}
