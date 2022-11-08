//
//  ViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, CustomView {
    // MARK: 글자수 11자 제한 + 한글 입력 제한 필요
    
    lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.login))
    lazy var getMessageButton: UIButton = customButton(title: "인증 문자 받기")
    lazy var underlineView: UIView = customUnderlineView()
    
    let phoneNumberTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        view.keyboardType = .numberPad
        return view
    }()
    
    let vm = LoginViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = LoginViewModel.Input(
            getMessageButtonTap: getMessageButton.rx.tap
                .withLatestFrom(phoneNumberTextField.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
            
            phoneNumberTextField: phoneNumberTextField.rx.text.orEmpty
                .asSignal(onErrorJustReturn: "")
        )
        
        let output = vm.transform(input: input)
    
        output.pushNextVC
            .emit { [weak self] _ in
                self?.navigationController?.pushViewController(AuthenticateViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.withHypen
            .withUnretained(self)
            .emit { vc, withHypen in
                vc.phoneNumberTextField.text = withHypen
            }
            .disposed(by: disposeBag)
        
        output.validate
            .withUnretained(self)
            .emit { vc, validate in
                vc.getMessageButton.backgroundColor = (validate == true) ? .setColor(.green) : .systemGray
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        [titleLabel, phoneNumberTextField, getMessageButton, underlineView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(26)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
        
        getMessageButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(phoneNumberTextField)
            make.height.equalTo(48)
        }
    }
}
