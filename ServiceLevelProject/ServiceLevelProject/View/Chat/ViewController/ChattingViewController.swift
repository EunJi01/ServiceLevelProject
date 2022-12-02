//
//  ChattingViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa

final class ChattingViewController: UIViewController, CustomView {
    let disposeBag = DisposeBag()
    let vm = ChattingViewModel()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(MyChatTableViewCell .self, forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier)
        view.register(OtherUserChatTableViewCell.self, forCellReuseIdentifier: OtherUserChatTableViewCell.reuseIdentifier)
        view.separatorStyle = .none
        return view
    }()
    
    private let chatView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .setColor(.gray1)
        return view
    }()
    
    private let sendButton: UIButton = {
        let view = UIButton()
        view.setImage(.setImage(.send), for: .normal)
        return view
    }()
    
    private let chatTextView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private let backButton = UIBarButtonItem(image: IconSet.backButton, style: .done, target: nil, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bind()
        setConfigure()
        setConstraints()
        
        vm.myState()
        NotificationCenter.default.addObserver(self, selector: #selector(vm.getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection()
    }
    
    private func bind() {
        let input = ChattingViewModel.Input(
            sendButton: sendButton.rx.tap
                .withLatestFrom(chatTextView.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
//            returnKey: chatTextView.rx.didEndEditing
//                .withUnretained(chatTextView.rx.text.orEmpty)
//                .asSignal(onErrorJustReturn: ""),
            chatTextView: chatTextView.rx.text.orEmpty.asSignal(onErrorJustReturn: ""),
            backButton: backButton.rx.tap.asSignal()
        )
        
        let output = vm.transform(input: input)
        
        output.highlight
            .withUnretained(self)
            .emit { vc, highlight in
                let image: UIImage = (highlight == true) ? .setImage(.sendFill) : .setImage(.send)
                vc.sendButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.changeTitle
            .withUnretained(self)
            .emit { vc, nick in
                vc.navigationItem.title = nick
            }
            .disposed(by: disposeBag)
        
        output.getMessage
            .withUnretained(self)
            .emit { vc, _ in
                print("tableView reloadData")
                vc.tableView.reloadData()
                vc.tableView.scrollToRow(at: IndexPath(row: vc.vm.chatList.count - 1, section: 0), at: .bottom, animated: false)
            }
            .disposed(by: disposeBag)
        
        output.popVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        [tableView, chatView].forEach {
            view.addSubview($0)
        }
        
        [chatTextView, sendButton].forEach {
            chatView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        chatView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(52)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(chatView.snp.top).offset(-16)
            make.horizontalEdges.equalToSuperview()
        }
        
        chatTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(14)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(chatTextView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(14)
            make.height.width.equalTo(20)
        }
    }
}

extension ChattingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = vm.chatList[indexPath.row]
        
        if data.from == UserDefaults.uid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier) as? MyChatTableViewCell else { return UITableViewCell() }
            
            cell.myChatViewLabel.text = data.chat
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherUserChatTableViewCell.reuseIdentifier) as? OtherUserChatTableViewCell else { return UITableViewCell() }
            
            cell.otherUserChatLabel.text = data.chat
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.chatList.count
    }
}
