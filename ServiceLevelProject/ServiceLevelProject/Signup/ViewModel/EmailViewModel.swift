//
//  EmailViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

enum EmailToast: String {
    case notValid = "이메일 형식이 올바르지 않습니다."
}

final class EmailViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTap: Signal<String>
        let emailTextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let showToast: Signal<String>
        let highlight: Signal<Bool>
        let validate: Signal<Bool>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let highlightRelay = PublishRelay<Bool>()
    private let validateRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.nextButtonTap
            .withUnretained(self)
            .emit { vm, email in
                if vm.validateEmail(email: email) {
                    UserDefaults.userEmail = email
                    vm.pushNextVCRelay.accept(())
                } else {
                    vm.showToastRelay.accept(EmailToast.notValid.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        input.emailTextField
            .withUnretained(self)
            .emit { vm, email in
                let editing = (email.count > 0 )
                vm.highlightRelay.accept(editing)
            }
            .disposed(by: disposeBag)
        
        input.emailTextField
            .withUnretained(self)
            .emit { vm, email in
                let validate = vm.validateEmail(email: email)
                vm.validateRelay.accept(validate)
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            highlight: highlightRelay.asSignal(),
            validate: validateRelay.asSignal()
        )
    }
}

extension EmailViewModel {
    private func validateEmail(email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}$"
        return NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: email)
    }
}
