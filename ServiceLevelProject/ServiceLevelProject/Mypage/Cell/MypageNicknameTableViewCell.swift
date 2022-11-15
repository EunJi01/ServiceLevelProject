//
//  MypageNicknameTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit

final class MypageNicknameTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.setColor(.gray2).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let nicknameLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        return view
    }()

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
        [profileImageView, nicknameLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.verticalEdges.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(2)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(14)
            make.centerY.equalTo(profileImageView.snp.centerY).inset(14)
        }
    }
}
