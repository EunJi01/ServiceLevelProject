//
//  GenderViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

final class GenderViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTap: Signal<String>
        let birthTextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let showToast: Signal<String>
        let highlight: Signal<Bool>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let highlightRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.birthTextField
            .withUnretained(self)
            .emit { vm, nickname in
                if (1...10).contains(nickname.count) {
                    vm.highlightRelay.accept(true)
                } else {
                    vm.highlightRelay.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            highlight: highlightRelay.asSignal()
        )
    }
}
