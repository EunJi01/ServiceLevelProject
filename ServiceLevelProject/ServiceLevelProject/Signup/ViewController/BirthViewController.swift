//
//  BirthViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

final class BirthViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    private let vm = BirthViewModel()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.birth))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    private lazy var underlineView: UIView = customUnderlineView()
    
    private lazy var yearTextField: UITextField = customTextField(placeholder: "1990")
    private lazy var monthTextField: UITextField = customTextField(placeholder: "1")
    private lazy var dayTextField: UITextField = customTextField(placeholder: "1")
    
    
    
    // MARK: 스텍뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        yearTextField.becomeFirstResponder()
        
    }
    
    private func bind() {

    }
    
    private func setConfigure() {
        [titleLabel, nextButton, underlineView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
//        emailTextField.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(80)
//            make.horizontalEdges.equalToSuperview().inset(26)
//            make.height.equalTo(48)
//        }
//
//        underlineView.snp.makeConstraints { make in
//            make.top.equalTo(emailTextField.snp.bottom)
//            make.horizontalEdges.equalTo(emailTextField).inset(-10)
//            make.height.equalTo(1)
//        }
//
//        nextButton.snp.makeConstraints { make in
//            make.top.equalTo(emailTextField.snp.bottom).offset(72)
//            make.horizontalEdges.equalTo(underlineView)
//            make.height.equalTo(48)
//        }
    }
    
    deinit {
        print(#function)
    }
}
