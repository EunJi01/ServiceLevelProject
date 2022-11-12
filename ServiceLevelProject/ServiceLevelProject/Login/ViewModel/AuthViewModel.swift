//
//  Login2ViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import Foundation
import RxSwift
import RxCocoa

enum AuthToast: String {
    case sendMessage = "인증번호를 보냈습니다."
    case discrepancy = "전화번호 인증 실패"
    case tokenError = "에러가 발생했습니다. 잠시 후 다시 시도해주세요."
}

final class AuthViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let resendButtonTap: Signal<Void>
        let startButtonTap: Signal<String>
        let numbertextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let highlight: Signal<Bool>
        let validate: Signal<Bool>
        let showToast: Signal<String>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let highlightRelay = PublishRelay<Bool>()
    private let validateRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.startButtonTap
            .withUnretained(self)
            .emit { vm, number in
                let verificationID = UserDefaults.authVerificationID
                let credential = FirebaseAuth.shared.credential(verificationID: verificationID, number: number)
                FirebaseAuth.shared.login(credential: credential) { [weak self] authDataResult, error in
                    if error != nil {
                        self?.showToastRelay.accept(AuthToast.discrepancy.rawValue)
                    } else {
                        UserDefaults.didAuth = true
                        self?.pushNextVCRelay.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.numbertextField
            .withUnretained(self)
            .emit { vm, number in
                let validate = (number.count == 6)
                vm.validateRelay.accept(validate)
            }
            .disposed(by: disposeBag)
        
        input.numbertextField
            .withUnretained(self)
            .emit { vm, number in
                let editing = (1...5).contains(number.count)
                vm.highlightRelay.accept(editing)
            }
            .disposed(by: disposeBag)
        
        input.resendButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.showToastRelay.accept(AuthToast.sendMessage.rawValue)
                let number = UserDefaults.userPhoneNumber
                FirebaseAuth.shared.requestVerificationID(number: number) { verificationID, error in
                    if let verificationID = verificationID {
                        UserDefaults.authVerificationID = verificationID
                    } else {
                        vm.showToastRelay.accept(ValidationToast.otherErrors.rawValue)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            highlight: highlightRelay.asSignal(),
            validate: validateRelay.asSignal(),
            showToast: showToastRelay.asSignal()
        )
    }
}
