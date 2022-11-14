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
    
    private lazy var yearTextField: UITextField = customTextField(placeholder: "1990")
    private lazy var monthTextField: UITextField = customTextField(placeholder: "1")
    private lazy var dayTextField: UITextField = customTextField(placeholder: "1")
    
    private lazy var yearUnderlineView: UIView = customUnderlineView()
    private lazy var monthUnderlineView: UIView = customUnderlineView()
    private lazy var dayUnderlineView: UIView = customUnderlineView()
    
    private lazy var yearLabel: UILabel = customTitleLabel(size: 16, text: "년", aligment: .left)
    private lazy var monthLabel: UILabel = customTitleLabel(size: 16, text: "월", aligment: .left)
    private lazy var dayLabel: UILabel = customTitleLabel(size: 16, text: "일", aligment: .left)
    
    private lazy var textFieldStackView = UIStackView(arrangedSubviews: [
        yearTextField, yearLabel, monthTextField, monthLabel, dayTextField, dayLabel
    ])
    
    private lazy var underlineFieldStackView = UIStackView(arrangedSubviews: [
        yearUnderlineView, monthUnderlineView, dayUnderlineView
    ])
    
    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        yearTextField.inputView = datePicker
        monthTextField.inputView = datePicker
        dayTextField.inputView = datePicker
        
        bind()
        setTextField()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = BirthViewModel.Input(
            nextButtonTap: nextButton.rx.tap
                .withLatestFrom(datePicker.rx.date)
                .asSignal(onErrorJustReturn: Date()),
            datePicker: datePicker.rx.date
                .asSignal(onErrorJustReturn: Date()),
            yearTextField: yearTextField.rx.text.orEmpty
                .asSignal(onErrorJustReturn: "")
        )
        
        let output = vm.transform(input: input)
        
        output.pushNextVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.transition(EmailViewController(), transitionStyle: .push)
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
                vc.nextButton.backgroundColor = (highlight == true) ? .setColor(.green) : .setColor(.gray6)
            }
            .disposed(by: disposeBag)
        
        output.birth
            .withUnretained(self)
            .emit { vc, birth in
                vc.yearTextField.text = birth.0
                vc.monthTextField.text = birth.1
                vc.dayTextField.text = birth.2
            }
            .disposed(by: disposeBag)
    }
    
    private func setTextField() {
        guard let birth = UserDefaults.userBirth?.separateDate else { return }
        nextButton.backgroundColor = .setColor(.green)

        yearTextField.text = birth.0
        monthTextField.text = birth.1
        dayTextField.text = birth.2
    }
    
    private func setConfigure() {
        textFieldStackView.spacing = 35
        textFieldStackView.distribution = .equalCentering
        underlineFieldStackView.spacing = 42
        underlineFieldStackView.distribution = .fillEqually
        yearTextField.tintColor = .clear
        
        [titleLabel, nextButton, textFieldStackView, underlineFieldStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
        
        underlineFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(35)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(underlineFieldStackView.snp.bottom).offset(72)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    deinit {
        print(#function)
    }
}
