//
//  MyChatTableViewCell.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/01.
//

import UIKit

final class MyChatTableViewCell: UITableViewCell, CustomView {
    
    private let myChatView: UIView = {
        let view = UIView()
        view.backgroundColor = .setColor(.whitegreen)
        view.layer.cornerRadius = 10
        return view
    }()

    lazy var myChatViewLabel = customTitleLabel(size: 14, text: "", aligment: .left)
    lazy var myChatTimeLabel = customTitleLabel(size: 12, text: "00:00")

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
        myChatTimeLabel.textColor = .setColor(.gray6)

        [myChatView, myChatTimeLabel, myChatViewLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        myChatView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(myChatViewLabel.snp.verticalEdges).inset(-10)
            make.horizontalEdges.equalTo(myChatViewLabel.snp.horizontalEdges).inset(-16)
            make.leading.greaterThanOrEqualToSuperview().inset(120)
            make.trailing.equalToSuperview().inset(16)
        }
        
        myChatTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(myChatView.snp.leading).offset(-8)
            make.bottom.equalTo(myChatView.snp.bottom)
        }
        
        myChatViewLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(22)
        }
    }
}
