//
//  GenderViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

enum Gender: String {
    case woman = "0"
    case man = "1"
}

final class GenderViewModel {
    private let disposeBag = DisposeBag()
    private var gender: Gender?
    
    struct Input {
        let nextButtonTap: Signal<Void>
        let manButtonTap: Signal<Void>
        let womanButtonTap: Signal<Void>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let buttonHighlight: Signal<Gender>
        let validate: Signal<Bool>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let buttonHighlightRelay = PublishRelay<Gender>()
    private let validateRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.womanButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.validateRelay.accept(true)
                vm.buttonHighlightRelay.accept(.woman)
                vm.gender = .woman
            }
            .disposed(by: disposeBag)
        
        input.manButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.validateRelay.accept(true)
                vm.buttonHighlightRelay.accept(.man)
                vm.gender = .man
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .withUnretained(self)
            .emit { vm, _ in
                vm.postUserInfo()
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            buttonHighlight: buttonHighlightRelay.asSignal(),
            validate: validateRelay.asSignal()
        )
    }
    
    func postUserInfo() {
//        let nickname =
//        let birth =
//        let email =
//        let gender =
    }
}
