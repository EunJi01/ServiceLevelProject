//
//  ViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    private let vm = LoginViewModel()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.login))
    private lazy var getMessageButton: UIButton = customButton(title: "인증 문자 받기")
    private lazy var underlineView: UIView = customUnderlineView()
    private lazy var phoneNumberTextField: UITextField = customTextField(placeholder: "휴대폰 번호(-없이 숫자만 입력)", keyboard: .numberPad)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        phoneNumberTextField.becomeFirstResponder()
        phoneNumberTextField.text = UserDefaults.userPhoneNumber
        
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
                .asSignal(onErrorJustReturn: ""),
            excessiveRequestTap: getMessageButton.rx.tap.asSignal()
        )
        
        let output = vm.transform(input: input)
    
        output.pushNextVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.transition(AuthViewController(), transitionStyle: .push)
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
                vc.getMessageButton.backgroundColor = (validate == true) ? .setColor(.green) : .setColor(.gray6)
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.highlight
            .withUnretained(self)
            .emit { vc, highlight in
                vc.underlineView.backgroundColor = (highlight == true) ? .setColor(.focus) : .setColor(.gray3)
            }
            .disposed(by: disposeBag)
        
        output.numberLimit
            .withUnretained(self)
            .emit { vc, number in
                vc.phoneNumberTextField.text = number
            }
            .disposed(by: disposeBag)
        
        output.keyboardDisappear
            .withUnretained(self)
            .emit { vc, _ in
                vc.view.endEditing(true)
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
            make.horizontalEdges.equalTo(phoneNumberTextField).inset(-10)
            make.height.equalTo(1)
        }
        
        getMessageButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(underlineView)
            make.height.equalTo(48)
        }
    }
    
    deinit {
        print(#function)
    }
}
