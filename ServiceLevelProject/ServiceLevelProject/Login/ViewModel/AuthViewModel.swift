//
//  Login2ViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

enum AuthToast: String {
    case sendMessage = "인증번호를 보냈습니다."
    case timeout, discrepancy = "전화번호 인증 실패"
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
    
    let pushNextVCRelay = PublishRelay<Void>()
    let highlightRelay = PublishRelay<Bool>()
    let validateRelay = PublishRelay<Bool>()
    let showToastRelay = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        
        input.startButtonTap
            .withUnretained(self)
            .emit { vm, number in
                guard let verificationID = UserDefaults.standard.string(forKey: UserDefaultSet.authVerificationID) else { return }
                let credential = PhoneAuthProvider.provider().credential(
                  withVerificationID: verificationID,
                  verificationCode: number
                )
                vm.login(credential: credential)
            }
            .disposed(by: disposeBag)
        
        input.numbertextField
            .withUnretained(self)
            .emit { vm, number in
                if number.count == 6 {
                    vm.validateRelay.accept(true)
                } else {
                    vm.validateRelay.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.numbertextField
            .withUnretained(self)
            .emit { vm, number in
                if (1...5).contains(number.count) {
                    vm.highlightRelay.accept(true)
                } else {
                    vm.highlightRelay.accept(false)
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
    
    private func login(credential: PhoneAuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                // MARK: 에러 종류에 따른 토스트 띄우기
                self?.showToastRelay.accept(AuthToast.timeout.rawValue)
                print("로그인 실패 === \(error)")
            } else {
                self?.pushNextVCRelay.accept(())
            }
        }
    }
}

