//
//  NicknameViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import Foundation
import RxSwift
import RxCocoa

enum NicknameToast: String {
    case countError = "닉네임은 1자 이상 10자 이내로 부탁드려요."
    case notAvailable = "해당 닉네임은 사용할 수 없습니다."
}

final class NicknameViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTap: Signal<String>
        let nicknameTextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let showToast: Signal<String>
        let highlight: Signal<Bool>
    }
    
    let pushNextVCRelay = PublishRelay<Void>()
    let showToastRelay = PublishRelay<String>()
    let highlightRelay = PublishRelay<Bool>()
    
    func transform(input: Input) -> Output {
        
        input.nextButtonTap
            .withUnretained(self)
            .emit { vm, nickname in
                switch nickname.count {
                case 1...10:
                    // 닉네임 저장
                    vm.pushNextVCRelay.accept(())
                default:
                    // 회원가입 최종 플로우 실패 조건 추가
                    vm.showToastRelay.accept(NicknameToast.countError.rawValue)
                }
            }
            .disposed(by: disposeBag)
        
        input.nicknameTextField
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
