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
        let presentMainVC: Signal<Void>
        let buttonHighlight: Signal<Gender>
        let validate: Signal<Bool>
        let showToast: Signal<String?>
    }
    
    private let presentMainVCRelay = PublishRelay<Void>()
    private let buttonHighlightRelay = PublishRelay<Gender>()
    private let validateRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String?>()
    
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
            presentMainVC: presentMainVCRelay.asSignal(),
            buttonHighlight: buttonHighlightRelay.asSignal(),
            validate: validateRelay.asSignal(),
            showToast: showToastRelay.asSignal()
        )
    }
    
    private func validate() {
        if UserDefaults.userGender == 10 {
            showToastRelay.accept(GenderToast.notValid.rawValue)
        } else {
            APIManager.shared.post(endpoint: .signup) { [weak self] statusCode in
                switch statusCode {
                case .success:
                    self?.presentMainVCRelay.accept(())
                    UserDefaults.alreadySigned = true
                case .alreadySigned:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                case .nicknameError:
                    // MARK: 부적절한 닉네임 -> 닉네임 화면 이동
                    print("부적절한 닉네임 -> 닉네임 화면 이동")
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }
}
