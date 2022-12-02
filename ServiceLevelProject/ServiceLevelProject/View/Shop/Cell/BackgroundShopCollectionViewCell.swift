//
//  ShopBackgroundCollectionViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/02.
//

import UIKit

final class BackgroundShopCollectionViewCell: UICollectionViewCell, CustomView {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setColor(.gray2).cgColor
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    let buyButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .setColor(.green)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 12)
        view.setTitle("1,200", for: .normal)
        view.layer.cornerRadius = 10
        return view
    }()

    lazy var backgroundLabel = customTitleLabel(size: 16, text: "배경이름")
    lazy var backgroundDescriptionLabel = customTitleLabel(size: 14, text: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다", aligment: .left, lineBreakMode: .byCharWrapping)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        [backgroundImageView, backgroundLabel, backgroundDescriptionLabel, buyButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        
        backgroundImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.bottom.equalToSuperview()
            make.height.width.equalTo(width)
        }
        
        backgroundLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-20)
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(12)
        }

        backgroundDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundLabel.snp.bottom).offset(12)
            make.leading.equalTo(backgroundLabel.snp.leading)
            make.width.equalTo(width)
        }

        buyButton.snp.makeConstraints { make in
            make.centerY.equalTo(backgroundLabel.snp.centerY)
            make.trailing.equalTo(backgroundDescriptionLabel.snp.trailing)
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
    }
}
