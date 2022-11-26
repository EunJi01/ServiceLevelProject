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
    var recommendedStudy: [String] = []
    var nearbyStudy: [String] = []
    var wishStudy: [String] = []
    
    struct Input {
        let returnKey: Signal<String>
        let searchSesacButton: Signal<Void>
    }
    
    struct Output {
        let addStudy: Signal<Void>
        let showToast: Signal<String?>
        let searchSesac: Signal<Void>
        let pushNextVC: Signal<Void>
    }
    
    private let addStudyRelay = PublishRelay<Void>()
    private let showToastRealy = PublishRelay<String?>()
    private let searchSesacRealy = PublishRelay<Void>()
    private let pushNextVCRelay = PublishRelay<Void>()
    
    func transform(input: Input) -> Output {
        input.returnKey
            .withUnretained(self)
            .emit { vm, text in
                vm.validate(text: text)
            }
            .disposed(by: disposeBag)
        
        input.searchSesacButton
            .withUnretained(self)
            .emit { vm, _ in
                //vm.searchSesac()
                vm.pushNextVCRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            addStudy: addStudyRelay.asSignal(),
            showToast: showToastRealy.asSignal(),
            searchSesac: searchSesacRealy.asSignal(),
            pushNextVC: pushNextVCRelay.asSignal()
        )
    }
    
    func validate(text: String) {
        let studyList = text.components(separatedBy: " ")

        for study in studyList {
            if wishStudy.contains(study) {
                showToastRealy.accept(StudySearchToast.alreadyAdded.rawValue)
            } else if !((1...8).contains(study.count)) {
                showToastRealy.accept(StudySearchToast.studyCount.rawValue)
            } else if wishStudy.count > 7 {
                showToastRealy.accept(StudySearchToast.studyListCount.rawValue)
            } else {
                wishStudy.append(study)
                addStudyRelay.accept(())
            }
        }
    }
    
    private func searchSesac() {
        guard let center = center else {
            showToastRealy.accept(StudySearchToast.unknownError.rawValue)
            return
        }
        
        if wishStudy.isEmpty {
            wishStudy.append("anything")
        }
        
        APIManager.shared.sesac(endpoint: .queueRequest(lat: center.latitude, long: center.longitude, studyList: wishStudy)) { [weak self] response in
            switch response {
            case .success(_):
                self?.pushNextVCRelay.accept(())
            case .failure(let statusCode):
                self?.showToastRealy.accept(statusCode.errorDescription)
            }
        }
    }
}
