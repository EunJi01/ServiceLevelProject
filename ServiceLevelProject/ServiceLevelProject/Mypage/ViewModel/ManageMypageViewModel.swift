//
//  ManageMypageViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/13.
//

import Foundation
import RxSwift
import RxCocoa

final class ManageMypageViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let saveButton: Signal<Void>
    }
    
    struct Output {
        let updateUserInfo: Signal<Void>
        let showToast: Signal<String?>
        let getUserInfo: Signal<UpdateUserInfo>
        let switchIsOn: Signal<Bool?>
    }
    
    private let updateUserInfoRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String?>()
    private let getUserInfoRelay = PublishRelay<UpdateUserInfo>()
    private let switchIsOnRelay = PublishRelay<Bool?>()
    
    func transform(input: Input) -> Output {
        input.saveButton
            .withUnretained(self)
            .emit { vm, update in
                print("저장")
                //vm.updateUserInfoRelay
            }
            .disposed(by: disposeBag)
        
        return Output(
            updateUserInfo: updateUserInfoRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            getUserInfo: getUserInfoRelay.asSignal(),
            switchIsOn: switchIsOnRelay.asSignal()
        )
    }
    
    private func updateUserInfo() {
        // 값에 접근하고 싶으면 어떡하지... 근데 임의로 초기값 넣어놨다가 데이터 받아와서 고치기 전에 사용자가 저장하면 어떡하지...
//        APIManager.shared.put(endpoint:.mypage(searchable: <#T##Int#>, ageMin: <#T##Int#>, ageMax: <#T##Int#>, gender: <#T##Int#>, study: <#T##String#>))
//        { [weak self] statusCode in
//            switch statusCode {
//            case .success:
//                self?.switchIsOnRelay.accept(self?.switchIsOn())
//            default:
//                self?.showToastRelay.accept(statusCode.errorDescription)
//            }
//        }
    }
    
    func getUserInfo() {
        APIManager.shared.get(type: UpdateUserInfo.self, endpoint: .login) { [weak self] response in
            switch response {
            case .success(let userInfo):
                self?.getUserInfoRelay.accept(userInfo)
            case .failure(let statusCode):
                self?.showToastRelay.accept(statusCode.errorDescription)
            }
        }
    }
    
    private func switchIsOn() -> Bool {
        
        return true
    }
}
