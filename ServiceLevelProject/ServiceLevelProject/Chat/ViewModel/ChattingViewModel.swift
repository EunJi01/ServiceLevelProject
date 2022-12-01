//
//  ChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/28.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let sendButton: Signal<String>
        let chatTextView: Signal<String>
    }
    
    struct Output {
        let highlight: Signal<Bool>
        let showToast: Signal<String?>
    }
    
    private let highlightRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String?>()
    
    func transform(input: Input) -> Output {
        input.chatTextView
            .withUnretained(self)
            .emit { vm, text in
                vm.highlight(text: text)
            }
            .disposed(by: disposeBag)
        
        input.sendButton
            .withUnretained(self)
            .emit { vm, text in
                //vm.postChat(caht: text)
            }
            .disposed(by: disposeBag)
        
        return Output(
            highlight: highlightRelay.asSignal(),
            showToast: showToastRelay.asSignal()
            )
    }
}

extension ChattingViewModel {
    func fetchChat() {
        APIManager.shared.sesac(type: ChatList.self, endpoint: .fetchChat(from: "상대방 uid", lastChatDate: "DB 마지막 채팅 시간")) { [weak self] response in
            switch response {
            case .success(_):
                print("fetchChat success")
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.fetchChat()
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
    
    private func postChat(caht: String) {
        APIManager.shared.sesac(endpoint: .postChat(to: "상대방 uid", chat: caht)) { [weak self] response in
            switch response {
            case .success(_):
                print("postChat success")
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.fetchChat()
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
    
    private func highlight(text: String) {
        return text.isEmpty ? highlightRelay.accept(false) : highlightRelay.accept(true)
    }
}
