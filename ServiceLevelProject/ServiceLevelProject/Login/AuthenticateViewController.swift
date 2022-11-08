//
//  Login2ViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import UIKit

class AuthenticateViewController: UIViewController, CustomView {
    
    lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.login2))
    lazy var startButton: UIButton = customButton(title: "인증하고 시작하기")
    lazy var underlineView: UIView = customUnderlineView()
    
    let textField: UITextField = {
        let view = UITextField()
        view.placeholder = "인증번호 입력"
        view.keyboardType = .numberPad
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        
    }
    
    private func setConfigure() {
        [titleLabel, textField, startButton, underlineView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(26)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(textField)
            make.height.equalTo(48)
        }
    }
}
