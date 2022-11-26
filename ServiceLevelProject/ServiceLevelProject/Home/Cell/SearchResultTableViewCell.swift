//
//  SearchResultTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell, CustomView {
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let nicknameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.setColor(.gray2).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    let nicknameLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 16)
        return view
    }()
    
    lazy var requestButton: UIButton = customButton(title: "요청하기")
    let sesacImageView = UIImageView()

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
        requestButton.tintColor = .white
        requestButton.backgroundColor = .setColor(.error)
        
        [backgroundImageView, nicknameView].forEach {
            addSubview($0)
        }

        backgroundImageView.addSubview(sesacImageView)
        backgroundImageView.addSubview(requestButton)
        nicknameView.addSubview(nicknameLabel)
    }
    
    private func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(self.snp.width).multipliedBy(0.525)
        }

        sesacImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.2)
            make.height.width.equalTo(backgroundImageView.snp.height).multipliedBy(0.9)
        }

        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        requestButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
}
