//
//  BirthViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/10.
//

import Foundation
import RxSwift
import RxCocoa

enum BirthToast: String {
    case ageLimit = "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
}

final class BirthViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nextButtonTap: Signal<Date>
        let datePicker: Signal<Date>
        let yearTextField: Signal<String>
    }
    
    struct Output {
        let pushNextVC: Signal<Void>
        let showToast: Signal<String>
        let highlight: Signal<Bool>
        let birth: Signal<(String, String, String)>
    }
    
    private let pushNextVCRelay = PublishRelay<Void>()
    private let showToastRelay = PublishRelay<String>()
    private let highlightRelay = PublishRelay<Bool>()
    private let birthRealy = PublishRelay<(String, String, String)>()
    
    func transform(input: Input) -> Output {
        
        input.datePicker
            .withUnretained(self)
            .emit { vm, date in
                let birth = date.separateDate
                vm.birthRealy.accept(birth)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .withUnretained(self)
            .emit { vm, date in
                vm.validate(date: date)
            }
            .disposed(by: disposeBag)
        
        input.yearTextField
            .withUnretained(self)
            .emit { vm, text in
                vm.highlightRelay.accept(true)
            }
            .disposed(by: disposeBag)
        
        return Output(
            pushNextVC: pushNextVCRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            highlight: highlightRelay.asSignal(),
            birth: birthRealy.asSignal()
        )
    }
    
    private func validate(date: Date) {
        guard let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year else { return }

        if age < 17 {
            guard let birth = UserDefaults.userBirth else {
                showToastRelay.accept(BirthToast.ageLimit.rawValue)
                return
            }
            
            guard let age = Calendar.current.dateComponents([.year], from: birth, to: Date()).year, age > 16 else {
                showToastRelay.accept(BirthToast.ageLimit.rawValue)
                return
            }
        }
        
        UserDefaults.userBirth = date
        pushNextVCRelay.accept(())
    }
}
