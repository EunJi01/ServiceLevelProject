//
//  ShopSesacCollectionViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/02.
//

import UIKit

final class SesacShopCollectionViewCell: UICollectionViewCell, CustomView {
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.setColor(.gray2).cgColor
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

    lazy var sesacLabel = customTitleLabel(size: 16, text: "새싹이름")
    lazy var sesacDescriptionLabel = customTitleLabel(size: 14, text: "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", aligment: .left, lineBreakMode: .byCharWrapping)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        [sesacImageView, sesacLabel, sesacDescriptionLabel, buyButton].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        
        sesacImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.width.equalTo(width)
        }
        
        sesacLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImageView.snp.bottom).offset(12)
            make.leading.equalTo(sesacImageView.snp.leading)
        }

        sesacDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacLabel.snp.bottom).offset(12)
            make.leading.equalTo(sesacImageView.snp.leading)
            make.trailing.equalTo(sesacImageView.snp.trailing)
            make.bottom.equalToSuperview()
        }

        buyButton.snp.makeConstraints { make in
            make.top.equalTo(sesacLabel.snp.top)
            make.trailing.equalTo(sesacImageView.snp.trailing)
            make.height.equalTo(20)
            make.width.equalTo(52)
        }
    }
}
