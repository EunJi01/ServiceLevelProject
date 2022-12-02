//
//  SearchResultTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import UIKit

final class SearchResultTableViewCell: UITableViewCell, CustomView {
    let cardView = CardView()

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
        cardView.button.isHidden = false
        cardView.button.setTitle("요청하기", for: .normal)
        cardView.button.backgroundColor = .setColor(.error)
        
        [cardView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(cardView.height)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
