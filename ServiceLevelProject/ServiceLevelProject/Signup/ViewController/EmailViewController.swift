//
//  EmailViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

final class EmailViewController: UIViewController, CustomView {
    let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.email))
    private lazy var subTitleLabel: UILabel = customTitleLabel(size: 16, text: .setText(.emailSub))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    private lazy var underlineView: UIView = customUnderlineView()
    private lazy var emailTextField: UITextField = customTextField(placeholder: "SeSAC@email.com", keyboard: .emailAddress)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextField.becomeFirstResponder()
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {

    }
    
    private func setConfigure() {
        [titleLabel, emailTextField, nextButton, underlineView, subTitleLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(26)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.horizontalEdges.equalTo(emailTextField).inset(-10)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(underlineView)
            make.height.equalTo(48)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    deinit {
        print(#function)
    }
}
