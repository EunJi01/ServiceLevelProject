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
        let pushNextVC: Signal<Void>
    }
    
    private let showToastRelay = PublishRelay<String?>()
    private let pushNextVCRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        
        return Output(
            showToast: showToastRelay.asSignal(),
            pushNextVC: pushNextVCRelay.asSignal()
        )
    }
    
    func acceptStudy(user: FromQueueDB) {
        APIManager.shared.sesac(endpoint: .studyaccept(otheruid: user.uid)) { [weak self] response in
            switch response {
            case .success(_):
                self?.pushNextVCRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .error201:
                    self?.showToastRelay.accept("상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다")
                case .error202:
                    self?.showToastRelay.accept("상대방이 스터디 찾기를 그만두었습니다")
                case .error203:
                    self?.showToastRelay.accept("앗! 누군가가 나의 스터디를 수락하였어요!")
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.acceptStudy(user: user)
                        } else {
                            self?.showToastRelay.accept(statusCode.errorDescription)
                        }
                    }
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }
}
