//
//  NearbyViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa

final class NearbyViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let requestButton: Signal<Int>
    }
    
    struct Output {

    }
    
    private let showToastRelay = PublishRelay<String?>()
    
    func transform(input: Input) -> Output {
        input.requestButton
            .withUnretained(self)
            .emit { vm, index in
                // 채팅 요청
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}

extension NearbyViewModel {
    func requestStudy() {
        APIManager.shared.sesac(endpoint: .studyrequest) { response in
            switch response {
            case .success(_):
                print("성공이란다")
            case .failure(let statusCode):
                print("실패란다")
                // MARK: 머야 왜 토스트 안떠 귀찮게 ㅡ아아
                //showToastRelay.accept(statusCode.errorDescription)
            }
        }
    }
}
