//
//  GenderViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

enum Gender: Int {
    case woman = 0
    case man = 1
}

enum GenderToast: String {
    case notValid = "성별을 선택해주세요."
}

final class GenderViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTap: Signal<Void>
        let manButtonTap: Signal<Void>
        let womanButtonTap: Signal<Void>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let buttonHighlight: Signal<Gender>
        let validate: Signal<Bool>
        let showToast: Signal<String>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let buttonHighlightRelay = PublishRelay<Gender>()
    private let validateRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.womanButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.validateRelay.accept(true)
                vm.buttonHighlightRelay.accept(.woman)
                UserDefaults.userGender = Gender.woman.rawValue
            }
            .disposed(by: disposeBag)
        
        input.manButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.validateRelay.accept(true)
                vm.buttonHighlightRelay.accept(.man)
                UserDefaults.userGender = Gender.man.rawValue
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.validate()
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            buttonHighlight: buttonHighlightRelay.asSignal(),
            validate: validateRelay.asSignal(),
            showToast: showToastRelay.asSignal()
        )
    }
    
    private func validate() {
        if UserDefaults.userGender == 10 {
            showToastRelay.accept(GenderToast.notValid.rawValue)
        } else {
            // MARK: 네트워크 통신
            print(
                UserDefaults.showOnboarding,
                UserDefaults.didAuth,
                UserDefaults.authVerificationID,
                UserDefaults.userPhoneNumber,
                UserDefaults.userNickname,
                UserDefaults.userBirth,
                UserDefaults.userEmail,
                UserDefaults.userGender,
                UserDefaults.idToken
            )
        }
    }
}
