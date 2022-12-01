//
//  CattingTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/01.
//

import UIKit

final class OtherUserChatTableViewCell: UITableViewCell, CustomView {
    
    private let otherUserChatView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.setColor(.gray6).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var otherUserChatLabel = customTitleLabel(size: 14, text: "", aligment: .left)
    lazy var otherUserChatTimeLabel = customTitleLabel(size: 12, text: "00:00")

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
        otherUserChatTimeLabel.textColor = .setColor(.gray6)
        otherUserChatView.addSubview(otherUserChatLabel)
        
        [otherUserChatView, otherUserChatTimeLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        otherUserChatView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(120)
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        otherUserChatTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(otherUserChatView.snp.trailing).offset(8)
            make.bottom.equalTo(otherUserChatView.snp.bottom)
        }
        
        otherUserChatLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
