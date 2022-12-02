//
//  SearchResultTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell, CustomView {
    let cardView = CardView()
    lazy var requestButton: UIButton = customButton(title: "요청하기")

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
        
        [cardView, requestButton].forEach {
            contentView.addSubview($0)
            
            // contentView.isUserInteractionEnabled = true
        }
    }
    
    private func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(cardView.height)
            make.bottom.equalToSuperview().inset(12)
        }
        
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.top).inset(16)
            make.trailing.equalTo(cardView.snp.trailing).inset(16)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
}
