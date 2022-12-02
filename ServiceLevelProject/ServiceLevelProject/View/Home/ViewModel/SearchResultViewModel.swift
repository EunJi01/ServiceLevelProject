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
        let popVC: Signal<Void>
    }
    
    let refreshRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String?>()
    private let popVCRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.refreshButton
            .withUnretained(self)
            .emit { vm, _ in
                guard let center = vm.center else { return }
                vm.searchSesac(center: center)
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
            popVC: popVCRelay.asSignal()
        )
    }
}

extension SearchResultViewModel {
    func searchSesac(center: CLLocationCoordinate2D) {
        APIManager.shared.sesac(type: SearchSesac.self, endpoint: .queueSearch(lat: center.latitude, long: center.longitude)) { [weak self] response in
            switch response {
            case .success(let sesac):
                self?.result = sesac
                self?.refreshRelay.accept(())
            
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.searchSesac(center: center)
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
    
    func cancelMatching() {
        APIManager.shared.sesac(endpoint: .queueStop) { [weak self] response in
            switch response {
            case .success(_):
                self?.popVCRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .error201:
                    self?.showToastRelay.accept("현재 새싹 찾기 중이 아닙니다")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                        self?.popVCRelay.accept(())
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
