//
//  GenderViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

final class GenderViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    private let vm = GenderViewModel()

    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.gender))
    private lazy var subTitleLabel: UILabel = customTitleLabel(size: 16, text: .setText(.genderSub))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    private let manButton: UIButton = UIButton()
    private let womanButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UserDefaults.userGender = 10
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = GenderViewModel.Input(
            nextButtonTap: nextButton.rx.tap.asSignal(),
            manButtonTap: manButton.rx.tap.asSignal(),
            womanButtonTap: womanButton.rx.tap.asSignal()
            )
        
        let output = vm.transform(input: input)
        
        output.validate
            .withUnretained(self)
            .emit { vc, validate in
                vc.nextButton.backgroundColor = (validate == true) ? .setColor(.green) : .setColor(.gray6)
            }
            .disposed(by: disposeBag)
        
        output.buttonHighlight
            .withUnretained(self)
            .emit { vc, gender in
                switch gender {
                case .woman:
                    vc.setButtonConfiguration(button: vc.manButton, gender: .man, select: false)
                    vc.setButtonConfiguration(button: vc.womanButton, gender: .woman, select: true)
                case .man:
                    vc.setButtonConfiguration(button: vc.manButton, gender: .man, select: true)
                    vc.setButtonConfiguration(button: vc.womanButton, gender: .woman, select: false)
                }
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
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
    }
    
    private func setConfigure() {
        subTitleLabel.textColor = .setColor(.gray7)
        setButtonConfiguration(button: manButton, gender: .man, select: false)
        setButtonConfiguration(button: womanButton, gender: .woman, select: false)
        
        [titleLabel, nextButton, manButton, womanButton, subTitleLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(169)
            make.centerX.equalToSuperview()
        }
        
        manButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(66)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(view.snp.centerX).offset(-6)
            make.height.equalTo(124)
        }
        
        womanButton.snp.makeConstraints { make in
            make.top.equalTo(manButton.snp.top)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalTo(view.snp.centerX).offset(6)
            make.height.equalTo(manButton.snp.height)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(manButton.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setButtonConfiguration(button: UIButton, gender: Gender, select: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = (gender == .man) ? "남자" : "여자"
        config.image = (gender == .man) ? .setImage(.man) : .setImage(.woman)
        config.imagePadding = 10
        config.imagePlacement = .top
        config.background.strokeColor = .setColor(.gray3)
        config.background.strokeWidth = 1
        config.baseForegroundColor = .black
        
        switch select {
        case true: config.baseBackgroundColor = .setColor(.whitegreen)
        case false: config.baseBackgroundColor = .clear
        }
        
        button.configuration = config
    }

    deinit {
        print(#function)
    }
}
