//
//  ChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class ChattingViewModel {
    let disposeBag = DisposeBag()
    let socketIOManager = SocketIOManager()
    private let repository = ChatDBRepository()
    
    var otherUserUID: String?
    var lastChatDate = ""
    var tasks: [Chat] = []
    
    struct Input {
        let sendButton: Signal<String>
        let chatTextView: Signal<String>
        let backButton: Signal<Void>
        let cancelStudyButton: Signal<Void>
    }
    
    struct Output {
        let highlight: Signal<Bool>
        let showToast: Signal<String?>
        let changeTitle: Signal<String?>
        let popVC: Signal<Void>
        let reloadData: Signal<Void>
        let clearTextView: Signal<Void>
        let showAlert: Signal<String>
    }
    
    private let highlightRelay = PublishRelay<Bool>()
    private let showToastRelay = PublishRelay<String?>()
    private let changeTitleRelay = PublishRelay<String?>()
    private let popVCRelay = PublishRelay<Void>()
    private let reloadDataRelay = PublishRelay<Void>()
    private let clearTextViewRelay = PublishRelay<Void>()
    private let showAlertRelay = PublishRelay<String>()
    
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
                vm.postChat(chat: text)
            }
            .disposed(by: disposeBag)
        
        input.backButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.popVCRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        input.cancelStudyButton
            .withUnretained(self)
            .emit { vm, _ in
                vm.stateMessage()
            }
            .disposed(by: disposeBag)
        
        return Output(
            highlight: highlightRelay.asSignal(),
            showToast: showToastRelay.asSignal(),
            changeTitle: changeTitleRelay.asSignal(),
            popVC: popVCRelay.asSignal(),
            reloadData: reloadDataRelay.asSignal(),
            clearTextView: clearTextViewRelay.asSignal(),
            showAlert: showAlertRelay.asSignal()
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
                    self?.fetchDB()
                } else {
                    self?.showToastRelay.accept("현재 매칭된 새싹이 없습니다")
                }
                
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.myState()
                    }
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }
    
    private func fetchDB() {
        guard let uid = otherUserUID else { return }
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
        
        tasks = repository.fetch(uid: uid)
        reloadDataRelay.accept(())
        lastChatDate = tasks.last?.createdAt ?? ""
        fetchChat()
    }
    
    private func fetchChat() {
        guard let uid = otherUserUID else { return }
        print("===\(lastChatDate) 이후 서버 요청")

        APIManager.shared.sesac(type: ChatList.self, endpoint: .fetchChat(from: uid, lastChatDate: lastChatDate)) { [weak self] response in
            switch response {
            case .success(let chatList):
                self?.socketIOManager.establishConnection()
                //let a = chatList.payload.map { $0.createdAt.toDate.toString }
                // MARK: 날짜 대응하기ㅜㅜ!!!! 서버에서 UTC로 온다
                self?.tasks.append(contentsOf: chatList.payload)
                self?.repository.addChat(chatList: chatList.payload)
                self?.reloadDataRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.fetchChat()
                    }
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }
    
    private func postChat(chat: String) {
        guard let uid = otherUserUID else { return }
        
        APIManager.shared.sesac(endpoint: .postChat(to: uid, chat: chat)) { [weak self] response in
            switch response {
            case .success(_):
                let myChat = Chat(to: uid, from: UserDefaults.uid, chat: chat, createdAt: Date().toString)
                self?.tasks.append(myChat)
                self?.repository.addChat(chatList: [myChat])
                self?.reloadDataRelay.accept(())
                self?.clearTextViewRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .error201:
                    self?.showToastRelay.accept("스터디가 종료되어 채팅을 전송할 수 없습니다")
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.postChat(chat: chat)
                    }
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }
    
    func cancelStudy() {
        guard let uid = otherUserUID else { return }
        
        APIManager.shared.sesac(endpoint: .dodge(otheruid: uid)) { [weak self] response in
            switch response {
            case .success(_):
                self?.popVCRelay.accept(())
            case .failure(let statusCode):
                switch statusCode {
                case .error201:
                    self?.showToastRelay.accept("잘못된 요청입니다")
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.cancelStudy()
                    }
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }

    private func stateMessage() {
        APIManager.shared.sesac(type: State.self, endpoint: .myQueueState) { [weak self] response in
            switch response {
                
            case .success(let state):
                if state.matched == 1 {
                    self?.showAlertRelay.accept("스터디를 취소하시면 패널티가 부과됩니다")
                } else {
                    self?.showAlertRelay.accept("matched == 0 상대방이 스터디를 취소했기 떄문에 패널티가 부과되지 않습니다")
                }
                
            case .failure(let statusCode):
                switch statusCode {
                case .success:
                    self?.showAlertRelay.accept("SUCCESS - 상대방이 스터디를 취소했기 떄문에 패널티가 부과되지 않습니다")
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.myState()
                    }
                default:
                    self?.showToastRelay.accept(statusCode.errorDescription)
                }
            }
        }
    }
    
    func getMessage(notification: NSNotification) {
        let to = notification.userInfo!["to"] as! String
        let from = notification.userInfo!["from"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String

        let value = Chat(to: to, from: from, chat: chat, createdAt: createdAt)
        
        tasks.append(value)
        repository.addChat(chatList: [value])
        reloadDataRelay.accept(())
    }
    
    private func highlight(text: String) {
        return text.isEmpty ? highlightRelay.accept(false) : highlightRelay.accept(true)
    }
}
