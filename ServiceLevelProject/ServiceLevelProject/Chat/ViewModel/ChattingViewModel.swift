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
    
    var otherUserUID: String?
    var lastChatDate = ""
    var chatList: [Chat] = []
    
    struct Input {
        let sendButton: Signal<String>
        let chatTextView: Signal<String>
    }
    
    struct Output {
        let highlight: Signal<Bool>
        let showToast: Signal<String?>
        let changeTitle: Signal<String?>
        let getMessage: Signal<Void>
    }
    
    private let highlightRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String?>()
    private let changeTitleRelay = PublishRelay<String?>()
    private let getMessageRelay = PublishRelay<Void>()
    
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
                vm.postChat(caht: text)
            }
            .disposed(by: disposeBag)
        
        return Output(
            highlight: highlightRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            changeTitle: changeTitleRelay.asSignal(),
            getMessage: getMessageRelay.asSignal()
            )
    }
}

extension ChattingViewModel {
    func myState() {
        APIManager.shared.sesac(type: State.self, endpoint: .myQueueState) { [weak self] response in
            switch response {
                
            case .success(let state):
                if state.matched == 1 {
                    self?.otherUserUID = state.matchedUid
                    self?.changeTitleRelay.accept(state.matchedNick)
                    self?.fetchChat()
                    SocketIOManager.shared.establishConnection()
                } else {
                    self?.showToastRelay.accept("현재 매칭된 새싹이 없습니다")
                }
                
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.myState()
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
    
    private func fetchChat() {
        guard let uid = otherUserUID else { return }
        
        APIManager.shared.sesac(type: ChatList.self, endpoint: .fetchChat(from: uid, lastChatDate: lastChatDate)) { [weak self] response in
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
        guard let uid = otherUserUID else { return }
        
        APIManager.shared.sesac(endpoint: .postChat(to: uid, chat: caht)) { [weak self] response in
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
    
    @objc func getMessage(notification: NSNotification) {
        let to = notification.userInfo!["to"] as! String
        let from = notification.userInfo!["from"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        
        let value = Chat(to: to, from: from, chat: chat, createdAt: createdAt)
    
        chatList.append(value)
        getMessageRelay.accept(())
    }
    
    private func highlight(text: String) {
        return text.isEmpty ? highlightRelay.accept(false) : highlightRelay.accept(true)
    }
}
