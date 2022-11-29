//
//  NearbyViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa

final class NearbyViewModel: SearchResultViewModel {
    struct Input { }
    
    struct Output {
        let showToast: Signal<String?>
    }
    
    private let showToastRelay = PublishRelay<String?>()
    
    func transform(input: Input) -> Output {
        
        return Output(
            showToast: showToastRelay.asSignal()
        )
    }
}

extension NearbyViewModel {
    func requestStudy(user: FromQueueDB) {
        APIManager.shared.sesac(endpoint: .studyrequest(otheruid: user.uid)) { [weak self] response in
            switch response {
            case .success(_):
                self?.showToastRelay.accept("스터디 요청을 보냈습니다.")
            case .failure(let statusCode):
                self?.showToastRelay.accept(statusCode.errorDescription)
            }
        }
    }
}
