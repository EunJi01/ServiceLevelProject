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
    
    var info: UpdateUserInfo?
    
    struct Input {
        let manButton: Signal<Void>
        let womanButton: Signal<Void>
        let studyTextField: Signal<String>
        let searchableSwitch: Signal<Bool>
        //let ageGroupSlider: Signal<(Int, Int)>
        let saveButton: Signal<Void>
        let withdrawButton: Signal<Void>
    }
    
    struct Output {
        let save: Signal<Void>
        let showToast: Signal<String?>
        let getUserInfo: Signal<UpdateUserInfo>
        let switchIsOn: Signal<Bool>
        let withdraw: Signal<Void>
        let changeStudy: Signal<Void>
        let changeSearchable: Signal<Void>
    }
    
    private let saveRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String?>()
    private let getUserInfoRelay = PublishRelay<UpdateUserInfo>()
    private let switchIsOnRelay = PublishRelay<Bool>()
    private let withdrawRelay = PublishRelay<Void>()
    private let changeStudyRelay = PublishRelay<Void>()
    private let changeSearchableRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.saveButton
            .withUnretained(self)
            .emit { vm, update in
                print("저장")
                //vm.updateUserInfo()
                //vm.saveRelay
            }
            .disposed(by: disposeBag)
        
        input.withdrawButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.withdraw()
            }
            .disposed(by: disposeBag)
        
        input.studyTextField
            .withUnretained(self)
            .emit { vm, study in
                vm.info?.study = study
            }
            .disposed(by: disposeBag)
        
        input.studyTextField
            .withUnretained(self)
            .emit { vm, study in
                vm.info?.study = study
            }
            .disposed(by: disposeBag)
        
        input.searchableSwitch
            .withUnretained(self)
            .emit { vm, isOn in
                vm.info?.searchable = (isOn == false) ? 0 : 1
            }
            .disposed(by: disposeBag)
        
        return Output(
            save: saveRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            getUserInfo: getUserInfoRelay.asSignal(),
            switchIsOn: switchIsOnRelay.asSignal(),
            withdraw: withdrawRelay.asSignal(),
            changeStudy: changeStudyRelay.asSignal(),
            changeSearchable: changeSearchableRelay.asSignal()
        )
    }
}

extension ManageMypageViewModel {
    private func switchIsOn() {
        info?.searchable == 0 ? switchIsOnRelay.accept(false) : switchIsOnRelay.accept(true)
    }
}
 
extension ManageMypageViewModel {
    func getUserInfo() {
        APIManager.shared.sesac(type: UpdateUserInfo.self, endpoint: .login) { [weak self] response in
            switch response {
            case .success(let userInfo):
                self?.info = userInfo
                self?.getUserInfoRelay.accept(userInfo)
                self?.switchIsOn()
            case .failure(let statusCode):
                self?.showToastRelay.accept(statusCode.errorDescription)
            }
        }
    }
    
    private func updateUserInfo() {
//        guard let info = info else { return }
//        // MARK: 성별, 연령대 업데이트 구현필요
//
//        APIManager.shared.sesac(endpoint: .mypage(searchable: info.searchable, ageMin: info.ageMin, ageMax: info.ageMax, gender: info.gender, study: info.study)) { [weak self] response in
//            switch response {
//            case .success(_):
//                print("업데이트 성공!")
//                self?.saveRelay.accept(())
//            case .failure(let statusCode):
//                self?.showToastRelay.accept(statusCode.errorDescription)
//            }
//        }
    }
                
    
    private func withdraw() {
        APIManager.shared.sesac(endpoint: .withdraw) { [weak self] response in
            switch response {
            case .success(_):
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
            case .failure(let statusCode):
                self?.showToastRelay.accept(statusCode.errorDescription)
            }
        }
    }
}
