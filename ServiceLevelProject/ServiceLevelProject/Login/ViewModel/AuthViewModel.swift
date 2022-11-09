//
//  Login2ViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/08.
//

import Foundation
import RxSwift
import RxCocoa

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
    }
    
    let pushNextVCRelay = PublishRelay<Void>()
    let highlightRelay = PublishRelay<Bool>()
    let validateRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.startButtonTap
            .withUnretained(self)
            .emit { vm, number in
                // 유효한지 검증
                vm.pushNextVCRelay.accept(())
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
            validate: validateRelay.asSignal()
        )
    }
}

