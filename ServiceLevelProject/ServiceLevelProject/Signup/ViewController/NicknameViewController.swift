//
//  NicknameViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

final class NicknameViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    private let vm = NicknameViewModel()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.nickname))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    private lazy var underlineView: UIView = customUnderlineView()
    private lazy var nicknameTextField: UITextField = customTextField(placeholder: "10자 이내로 입력")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        nicknameTextField.becomeFirstResponder()
        nicknameTextField.text = UserDefaults.userNickname
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = NicknameViewModel.Input(
            nextButtonTap: nextButton.rx.tap
                .withLatestFrom(nicknameTextField.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
            nicknameTextField: nicknameTextField.rx.text.orEmpty
                .asSignal(onErrorJustReturn: "")
        )
        
        let output = vm.transform(input: input)
        
        output.pushNextVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.navigationController?.pushViewController(BirthViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.highlight
            .withUnretained(self)
            .emit { vc, highlight in
                vc.nextButton.backgroundColor = (highlight == true) ? .setColor(.green) : .setColor(.gray6)
                vc.underlineView.backgroundColor = (highlight == true) ? .setColor(.focus) : .setColor(.gray3)
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
        [titleLabel, nicknameTextField, nextButton, underlineView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(26)
            make.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(nicknameTextField).inset(-10)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(72)
            make.horizontalEdges.equalTo(underlineView)
            make.height.equalTo(48)
        }
    }
    
    deinit {
        print(#function)
    }
}
