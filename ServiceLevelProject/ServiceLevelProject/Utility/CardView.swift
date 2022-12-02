//
//  CardView.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import UIKit

final class CardView: UIView, CustomView {
    let width = UIScreen.main.bounds.width - (16 * 2)
    lazy var height = width * 0.5 + 58
    
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
    
    let sesacImageView = UIImageView()
    lazy var button = customButton(title: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        button.isHidden = true
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        [backgroundImageView, nicknameView, button].forEach {
            addSubview($0)
        }
        
        backgroundImageView.addSubview(sesacImageView)
        nicknameView.addSubview(nicknameLabel)
    }
    
    private func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(width).multipliedBy(0.5)
        }

        sesacImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(1.3)
            make.height.width.equalTo(backgroundImageView.snp.height).multipliedBy(0.9)
        }

        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top).inset(16)
            make.trailing.equalTo(backgroundImageView.snp.trailing).inset(16)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
}
