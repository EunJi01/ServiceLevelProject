//
//  StudySearchViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/23.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

enum StudySearchToast: String {
    case studyCount = "최소 한글자 이상, 최대 8글자까지 작성 가능합니다."
    case studyListCount = "스터디를 더 이상 추가할 수 없습니다."
    case alreadyAdded = "이미 등록된 스터디입니다."
    case unknownError = "알 수 없는 오류가 발생했습니다."
}

final class StudySearchViewModel {
    let disposeBag = DisposeBag()
    
    var center: CLLocationCoordinate2D?
    var recommendedStudy = BehaviorRelay<[String]>(value: [])
    var nearbyStudy = BehaviorRelay<[String]>(value: [])
    var wishStudy = BehaviorRelay<[String]>(value: [])
    
    struct Input {
        let returnKey: Signal<String>
        let searchSesacButton: Signal<Void>
    }
    
    struct Output {
        let addStudy: Signal<Void>
        let showToast: Signal<String?>
        let searchSesac: Signal<Void>
    }
    
    private let addStudyRelay = PublishRelay<Void>()
    private let showToastRealy = PublishRelay<String?>()
    private let searchSesacRealy = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.returnKey
            .withUnretained(self)
            .emit { vm, text in
                let studyList = text.components(separatedBy: " ")
                vm.validate(studyList: studyList)
                vm.addStudyRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input.searchSesacButton
            .withUnretained(self)
            .emit { vm, _ in
                
            }
            .disposed(by: disposeBag)
        
        return Output(
            addStudy: addStudyRelay.asSignal(),
            showToast: showToastRealy.asSignal(),
            searchSesac: searchSesacRealy.asSignal()
        )
    }
    
    private func validate(studyList: [String]) {
        if (wishStudy.value.count + studyList.count) > 8 {
            showToastRealy.accept(StudySearchToast.studyListCount.rawValue)
        }
        
        for study in studyList {
            if (1...10).contains(study.count) {
                wishStudy.accept([study])
            } else if wishStudy.value.contains(study) {
                showToastRealy.accept(StudySearchToast.alreadyAdded.rawValue)
            } else {
                showToastRealy.accept(StudySearchToast.studyCount.rawValue)
            }
        }
    }
    
    private func searchSesac() {
        guard let center = center else {
            showToastRealy.accept(StudySearchToast.unknownError.rawValue)
            return
        }
        
        APIManager.shared.sesac(endpoint: .queueRequest(lat: center.latitude, long: center.longitude, studyList: wishStudy.value)) { [weak self] response in
            switch response {
            case .success(_):
                print("성공! 화면전환")
            case .failure(let statusCode):
                self?.showToastRealy.accept(statusCode.errorDescription)
            }
        }
    }
}
