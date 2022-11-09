//
//  BirthViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

enum BirthToast: String {
    case ageLimit = "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
}

final class BirthViewModel {
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
                let editing = (1...10).contains(nickname.count)
                vm.highlightRelay.accept(editing)
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            highlight: highlightRelay.asSignal()
        )
    }
}
