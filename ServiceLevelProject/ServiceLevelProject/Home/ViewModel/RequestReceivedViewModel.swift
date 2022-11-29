//
//  RequestReceivedViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa

final class RequestReceivedViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let acceptButton: Signal<Int>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.acceptButton
            .withUnretained(self)
            .emit { vm, index in
                // 채팅 수락
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
