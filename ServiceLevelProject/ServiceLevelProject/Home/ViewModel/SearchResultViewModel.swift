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

final class SearchResultViewModel {
    let disposeBag = DisposeBag()
    
    var center: CLLocationCoordinate2D?
    var result: SearchSesac = SearchSesac(fromQueueDB: [], fromQueueDBRequested: [], fromRecommend: [])
    
    struct Input {
        //let requestButton: Signal<Int>
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
//        input.requestButton
//            .withUnretained(self)
//            .emit { vm, index in
//                // 채팅 요청
//            }
//            .disposed(by: disposeBag)
        
        input.refreshButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.refreshRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input.changeStudyButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.popRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            showToast: showToastRelay.asSignal(),
            refresh: refreshRelay.asSignal(),
            pop: popRelay.asSignal()
        )
    }
}
