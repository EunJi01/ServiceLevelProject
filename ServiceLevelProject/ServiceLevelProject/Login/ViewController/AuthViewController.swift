//
//  Login2ViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import UIKit
import RxCocoa
import RxSwift

final class AuthViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    private let vm = AuthViewModel()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.login2))
    private lazy var startButton: UIButton = customButton(title: "인증하고 시작하기")
    private lazy var underlineView: UIView = customUnderlineView()
    private lazy var numbertextField: UITextField = customTextField(placeholder: "인증번호 입력", keyboard: .numberPad)
    private lazy var resendButton: UIButton = customButton(title: "재전송")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        numbertextField.becomeFirstResponder()
        
        DispatchQueue.main.async { [weak self] in
            self?.view.makeToast(AuthToast.sendMessage.rawValue, position: .top)
        }
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = AuthViewModel.Input(
            resendButtonTap: resendButton.rx.tap.asSignal(),
            startButtonTap: startButton.rx.tap
                .withLatestFrom(numbertextField.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
            numbertextField: numbertextField.rx.text.orEmpty
                .asSignal(onErrorJustReturn: ""),
            excessiveRequestTap: resendButton.rx.tap.asSignal()
        )
        
        let output = vm.transform(input: input)
        
        output.pushSignupVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.presentMainVC
            .withUnretained(self)
            .emit { vc, _ in
                let vc = MainTabBarController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                vc.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.highlight
            .withUnretained(self)
            .emit { vc, highlight in
                vc.underlineView.backgroundColor = (highlight == true) ? .setColor(.focus) : .setColor(.gray3)
            }
            .disposed(by: disposeBag)
        
        output.validate
            .withUnretained(self)
            .emit { vc, validate in
                vc.startButton.backgroundColor = (validate == true) ? .setColor(.green) : .setColor(.gray6)
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        resendButton.backgroundColor = .setColor(.green)
        numbertextField.textContentType = .oneTimeCode
        
        [titleLabel, numbertextField, resendButton, startButton, underlineView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        numbertextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.leading.equalToSuperview().inset(26)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(numbertextField.snp.bottom)
            make.horizontalEdges.equalTo(numbertextField).inset(-10)
            make.height.equalTo(1)
        }
        
        resendButton.snp.makeConstraints { make in
            make.centerY.equalTo(numbertextField.snp.centerY)
            make.leading.equalTo(numbertextField.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(72)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(numbertextField.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    deinit {
        print(#function)
    }
}
