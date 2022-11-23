//
//  StudySearchViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/23.
//

import Foundation
import RxSwift
import RxCocoa

enum StudySearchToast: String {
    case studyCount = "최소 한글자 이상, 최대 8글자까지 작성 가능합니다."
    case studyListCount = "스터디를 더 이상 추가할 수 없습니다."
}

final class StudySearchViewModel {
    let disposeBag = DisposeBag()
    
    var recommendedStudy = BehaviorRelay<[String]>(value: ["스위프트", "파이썬", "알고리즘"])
    var wishStudy = BehaviorRelay<[String]>(value: [])
    
    struct Input {
        let returnKey: Signal<String>
    }
    
    struct Output {
        let addStudy: Signal<Void>
        let showToast: Signal<String>
    }
    
    private let addStudyRelay = PublishRelay<Void>()
    private let showToastRealy = PublishRelay<String>()
    
    func transform(input: Input) -> Output {
        input.returnKey
            .withUnretained(self)
            .emit { vm, text in
                let studyList = text.components(separatedBy: " ")
                vm.validate(studyList: studyList)
                vm.addStudyRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            addStudy: addStudyRelay.asSignal(),
            showToast: showToastRealy.asSignal()
        )
    }
    
    private func validate(studyList: [String]) {
        if (wishStudy.value.count + studyList.count) > 8 {
            showToastRealy.accept(StudySearchToast.studyListCount.rawValue)
        }
        
        for study in studyList {
            if (1...10).contains(study.count) {
                wishStudy.accept([study])
            } else {
                showToastRealy.accept(StudySearchToast.studyCount.rawValue)
            }
        }
    }
}
