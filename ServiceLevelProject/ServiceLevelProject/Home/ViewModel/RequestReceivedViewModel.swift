//
//  RequestReceivedViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/29.
//

import Foundation
import RxSwift
import RxCocoa

final class RequestReceivedViewModel: SearchResultViewModel {
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
    
    func requestStudy(user: FromQueueDB) {
        APIManager.shared.sesac(endpoint: .studyaccept(otheruid: user.uid)) { [weak self] response in
            switch response {
            case .success(_):
                print("수락 완료! 채팅 화면으로 전환하기")
                // MARK: 채팅 화면으로 전환
            case .failure(let statusCode):
                self?.showToastRelay.accept(statusCode.errorDescription)
            }
        }
    }
}
