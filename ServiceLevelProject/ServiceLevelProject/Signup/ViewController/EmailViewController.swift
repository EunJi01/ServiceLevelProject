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
    private let disposeBag = DisposeBag()
    private let vm = EmailViewModel()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.email))
    private lazy var subTitleLabel: UILabel = customTitleLabel(size: 16, text: .setText(.emailSub))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    private lazy var underlineView: UIView = customUnderlineView()
    private lazy var emailTextField: UITextField = customTextField(placeholder: "SeSAC@email.com", keyboard: .emailAddress)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emailTextField.becomeFirstResponder()
        emailTextField.text = UserDefaults.standard.string(forKey: UserDefaultsKey.userEmail)
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = EmailViewModel.Input(
            nextButtonTap: nextButton.rx.tap
                .withLatestFrom(emailTextField.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
            emailTextField: emailTextField.rx.text.orEmpty
                .asSignal(onErrorJustReturn: "")
        )
        
        let output = vm.transform(input: input)
        
        output.pushNextVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.navigationController?.pushViewController(GenderViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.highlight
            .withUnretained(self)
            .emit { vc, highlight in
                vc.underlineView.backgroundColor = (highlight == true) ? .setColor(.focus) : .setColor(.gray3)
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.validate
            .withUnretained(self)
            .emit { vc, validate in
                vc.nextButton.backgroundColor = (validate == true) ? .setColor(.green) : .setColor(.gray6)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        subTitleLabel.textColor = .setColor(.gray7)
        
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
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    deinit {
        print(#function)
    }
}
