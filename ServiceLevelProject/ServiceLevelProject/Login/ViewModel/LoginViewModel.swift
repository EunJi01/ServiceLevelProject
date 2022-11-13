//
//  ViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import Foundation
import RxSwift
import RxCocoa

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
        let excessiveRequestTap: Signal<Void>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let withHypen: Signal<String>
        let validate: Signal<Bool>
        let showToast: Signal<String>
        let highlight: Signal<Bool>
        let numberLimit: Signal<String>
        let keyboardDisappear: Signal<Void>
        let excessiveRequest: Signal<Void>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let phoneNumberRelay = PublishRelay<String>()
    private let validateRelay = BehaviorRelay<Bool>(value: false)
    private let showToastRelay = PublishRelay<String>()
    private let highlightRelay = PublishRelay<Bool>()
    private let numberLimitRelay = PublishRelay<String>()
    private let keyboardDisappearRelay = PublishRelay<Void>()
    private let excessiveRequestRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {

        input.getMessageButtonTap
            .withUnretained(self)
            .throttle(.seconds(4), latest: false)
            .emit { vm, number in
                switch vm.validateRelay.value {
                case true:
                    vm.keyboardDisappearRelay.accept(())
                    vm.showToastRelay.accept(ValidationToast.valid.rawValue)
                    FirebaseAuth.shared.requestVerificationID(number: number) { verificationID, error in
                        if let verificationID = verificationID {
                            let number = number.replacingOccurrences(of: "-", with: "")
                            UserDefaults.userPhoneNumber = number
                            UserDefaults.authVerificationID = verificationID
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
                let editing = (1...11).contains(number.count)
                vm.highlightRelay.accept(editing)
            }
            .disposed(by: disposeBag)
        
        input.excessiveRequestTap
            .skip(5)
            .map{ ValidationToast.excessiveRequest.rawValue }
            .emit(to: showToastRelay)
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            withHypen: phoneNumberRelay.asSignal(),
            validate: validateRelay.asSignal(onErrorJustReturn: false),
            showToast: showToastRelay.asSignal(),
            highlight: highlightRelay.asSignal(),
            numberLimit: numberLimitRelay.asSignal(),
            keyboardDisappear: keyboardDisappearRelay.asSignal(),
            excessiveRequest: excessiveRequestRelay.asSignal()
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
