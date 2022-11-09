//
//  ViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

enum ValidationToast: String {
    case valid = "전화번호 인증 시작"
    case notValid = "잘못된 전화번호 형식입니다."
    case excessiveRequest = "과도한 인증 시도가 있었습니다. 나중에 다시 시도해주세요."
    case otherErrors = "에러가 발생했습니다. 다시 시도해주세요."
}

final class LoginViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let getMessageButtonTap: Signal<String>
        let phoneNumberTextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let withHypen: Signal<String>
        let validate: Signal<Bool>
        let showToast: Signal<String>
        let highlight: Signal<Bool>
        let numberLimit: Signal<String>
        let keyboardDisappear: Signal<Void>
    }
    
    let pushNextVCRelay = PublishRelay<Void>()
    let phoneNumberRelay = PublishRelay<String>()
    let validateRelay = BehaviorRelay<Bool>(value: false)
    let showToastRelay = PublishRelay<String>()
    let highlightRelay = PublishRelay<Bool>()
    let numberLimitRelay = PublishRelay<String>()
    let keyboardDisappearRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        
        input.getMessageButtonTap
            .withUnretained(self)
            .emit { vm, number in
                switch vm.validateRelay.value {
                case true:
                    vm.keyboardDisappearRelay.accept(())
                    vm.showToastRelay.accept(ValidationToast.valid.rawValue)
                    PhoneAuthProvider.provider()
                        .verifyPhoneNumber("+82\(number)", uiDelegate: nil) { verificationID, error in
                            if let verificationID = verificationID {
                                UserDefaults.standard.set(verificationID, forKey: UserDefaultSet.authVerificationID)
                                vm.pushNextVCRelay.accept(())
                            } else {
                                vm.showToastRelay.accept(ValidationToast.otherErrors.rawValue)
                            }
                        }
                case false:
                    vm.showToastRelay.accept(ValidationToast.notValid.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        input.phoneNumberTextField
            .withUnretained(self)
            .emit { vm, number in
                let number = vm.numberLimit(number)
                vm.phoneNumberRelay.accept(number.withHypen)
                vm.numberLimitRelay.accept(number.withHypen)
            }
            .disposed(by: disposeBag)
        
        input.phoneNumberTextField
            .withUnretained(self)
            .emit { vm, number in
                let numberStr = vm.numberLimit(number)
                let numberInt = numberStr.replacingOccurrences(of: "-", with: "")
                let validate = vm.validatePhone(number: numberInt)
                vm.validateRelay.accept(validate)
            }
            .disposed(by: disposeBag)
        
        input.phoneNumberTextField
            .withUnretained(self)
            .emit { vm, number in
                if (1...11).contains(number.count) {
                    vm.highlightRelay.accept(true)
                } else {
                    vm.highlightRelay.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            withHypen: phoneNumberRelay.asSignal(),
            validate: validateRelay.asSignal(onErrorJustReturn: false),
            showToast: showToastRelay.asSignal(),
            highlight: highlightRelay.asSignal(),
            numberLimit: numberLimitRelay.asSignal(),
            keyboardDisappear: keyboardDisappearRelay.asSignal()
        )
    }
    
    private func validatePhone(number: String) -> Bool {
        let regex = "^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: number)
    }
    
    private func numberLimit(_ number: String) -> String {
        guard number.count > 13 else { return number }
        let index = number.index(number.startIndex, offsetBy: 13)
        return String(number[..<index])
    }
    
    deinit {
        print(#function)
    }
}
