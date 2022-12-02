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
        //let returnKey: Signal<String>
        let chatTextView: Signal<String>
        let backButton: Signal<Void>
    }
    
    struct Output {
        let highlight: Signal<Bool>
        let showToast: Signal<String?>
        let changeTitle: Signal<String?>
        let getMessage: Signal<Void>
        let popVC: Signal<Void>
    }
    
    private let highlightRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String?>()
    private let changeTitleRelay = PublishRelay<String?>()
    private let getMessageRelay = PublishRelay<Void>()
    private let popVCRelay = PublishRelay<Void>()
    
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
        
        input.backButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.popVCRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            highlight: highlightRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            changeTitle: changeTitleRelay.asSignal(),
            getMessage: getMessageRelay.asSignal(),
            popVC: popVCRelay.asSignal()
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
                SocketIOManager.shared.establishConnection()
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
                case .error201:
                    self?.showToastRelay.accept("스터디가 종료되어 채팅을 전송할 수 없습니다")
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
