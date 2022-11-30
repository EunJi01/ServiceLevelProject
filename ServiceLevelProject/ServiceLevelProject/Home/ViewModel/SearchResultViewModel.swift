//
//  SearchResultViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

class SearchResultViewModel {
    let disposeBag = DisposeBag()
    
    var center: CLLocationCoordinate2D?
    var result: SearchSesac = SearchSesac(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: [])
    
    struct Input {
        let refreshButton: Signal<Void>
        let changeStudyButton: Signal<Void>
    }
    
    struct Output {
        let showToast: Signal<String?>
        let refresh: Signal<Void>
        let pop: Signal<Void>
    }
    
    let refreshRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String?>()
    private let popRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.refreshButton
            .withUnretained(self)
            .emit { vm, _ in
                // MARK: 네트워크 통신 다시 하기
                vm.refreshRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input.changeStudyButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.cancelMatching()
            }
            .disposed(by: disposeBag)
        
        return Output(
            showToast: showToastRelay.asSignal(),
            refresh: refreshRelay.asSignal(),
            pop: popRelay.asSignal()
        )
    }
}

extension SearchResultViewModel {
    func cancelMatching() {
        APIManager.shared.sesac(endpoint: .queueStop) { [weak self] response in
            switch response {
            case .success(_):
                self?.popRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .error201:
                    self?.showToastRelay.accept("새싹 찾기 중이 아닙니다")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                        self?.popRelay.accept(())
                    }
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.cancelMatching()
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
