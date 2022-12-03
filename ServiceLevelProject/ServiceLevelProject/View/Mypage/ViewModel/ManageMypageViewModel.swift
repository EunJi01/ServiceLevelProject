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
        let popVC: Signal<Void>
        let showToast: Signal<String?>
        let getUserInfo: Signal<UpdateUserInfo>
        let switchIsOn: Signal<Bool>
        let withdraw: Signal<Void>
        let changeStudy: Signal<Void>
        let changeSearchable: Signal<Void>
        let changeGender: Signal<Int>
        let resetOnboarding: Signal<Void>
    }
    
    private let popVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String?>()
    private let getUserInfoRelay = PublishRelay<UpdateUserInfo>()
    private let switchIsOnRelay = PublishRelay<Bool>()
    private let withdrawRelay = PublishRelay<Void>()
    private let changeStudyRelay = PublishRelay<Void>()
    private let changeSearchableRelay = PublishRelay<Void>()
    private let changeGenderRelay = PublishRelay<Int>()
    private let resetOnboardingRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.saveButton
            .withUnretained(self)
            .emit { vm, update in
                vm.updateUserInfo()
            }
            .disposed(by: disposeBag)
        
        input.withdrawButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.withdrawRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input.manButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.info?.gender = 1
                vm.changeGenderRelay.accept(1)
            }
            .disposed(by: disposeBag)
        
        input.womanButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.info?.gender = 0
                vm.changeGenderRelay.accept(0)
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
            popVC: popVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            getUserInfo: getUserInfoRelay.asSignal(),
            switchIsOn: switchIsOnRelay.asSignal(),
            withdraw: withdrawRelay.asSignal(),
            changeStudy: changeStudyRelay.asSignal(),
            changeSearchable: changeSearchableRelay.asSignal(),
            changeGender: changeGenderRelay.asSignal(),
            resetOnboarding: resetOnboardingRelay.asSignal()
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
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.getUserInfo()
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
    
    private func updateUserInfo() {
        guard let info = info else { return }
        // MARK: 연령대 업데이트 구현 필요
        
        APIManager.shared.sesac(endpoint: .mypage(searchable: info.searchable, ageMin: info.ageMin, ageMax: info.ageMax, gender: info.gender, study: info.study)) { [weak self] response in
            switch response {
            case .success(_):
                self?.popVCRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.updateUserInfo()
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
                
    func withdraw() {
        APIManager.shared.sesac(endpoint: .withdraw) { [weak self] response in
            switch response {
            case .success(_):
                for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
                self?.resetOnboardingRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.withdraw()
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
