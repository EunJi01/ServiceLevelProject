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

class LoginViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let getMessageButtonTap: Signal<String>
        let phoneNumberTextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let withHypen: Signal<String>
        let validate: Signal<Bool>
    }
    
    let pushNextVCRelay = PublishRelay<Void>()
    let phoneNumber = PublishRelay<String>()
    let validate = BehaviorRelay<Bool>(value: false)
    let showToastRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.getMessageButtonTap
            .withUnretained(self)
            .emit { vm, number in
                switch vm.validate.value {
                case true:
                    // MARK: valid 토스트 띄우기 -> 아웃풋 추가
                    vm.showToastRelay.accept(ValidationToast.valid.rawValue)
                    
                    // 인증 요청하기
                    let phoneNumber = "+82\(number)"
//                    PhoneAuthProvider.provider()
//                      .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//                          print(verificationID)
//                          if let error = error {
//                              print(error)
//                            // toherErrors 토스트 띄우기
//                            return
//                          }
//                      }
                    vm.pushNextVCRelay.accept(())
                    
                case false:
                    vm.showToastRelay.accept(ValidationToast.notValid.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        input.phoneNumberTextField
            .withUnretained(self)
            .emit { vm, number in
                vm.phoneNumber.accept(number.withHypen)
            }
            .disposed(by: disposeBag)
        
        input.phoneNumberTextField
            .withUnretained(self)
            .emit { vm, number in
                let number = number.replacingOccurrences(of: "-", with: "")
                let validate = vm.validatePhone(number: number)
                vm.validate.accept(validate)
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            withHypen: phoneNumber.asSignal(),
            validate: validate.asSignal(onErrorJustReturn: false)
        )
    }
    
    private func validatePhone(number: String) -> Bool {
        let regex = "^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: number)
    }
}
