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
        chatTextView.delegate = self
        
        bind()
        setConfigure()
        setConstraints()
        
        vm.myState()
        setKeyboardObserver()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureTapped(tapGestureRecognizer:))))
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SocketIOManager.shared.closeConnection() // MARK: ㅠㅠ이거 호출돼도 SOCKET IS CONNECTED 로그가 자꾸 뜸
    }
    
    private func bind() {
        let input = ChattingViewModel.Input(
            sendButton: sendButton.rx.tap
                .withLatestFrom(chatTextView.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
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
        
        output.popVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.reloadData
            .withUnretained(self)
            .emit { vc, _ in
                vc.tableView.reloadData()
                vc.tableView.scrollToRow(at: IndexPath(row: vc.vm.tasks.count - 1, section: 0), at: .bottom, animated: false)
            }
            .disposed(by: disposeBag)
        
        output.clearTextView
            .withUnretained(self)
            .emit { vc, _ in
                vc.chatTextView.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func getMessage(notification: NSNotification) {
        vm.getMessage(notification: notification)
    }
    
    @objc private func gestureTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        // MARK: 묘하게 테이블뷰가 덜 내려오는 문제 있음
    }
    
    private func setConfigure() {
        [tableView, chatView, chatTextView, sendButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        chatView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(chatTextView.snp.top).offset(-30)
            make.horizontalEdges.equalToSuperview()
        }
        
        chatTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(chatView.snp.horizontalEdges).inset(16)
            make.verticalEdges.equalTo(chatView.snp.verticalEdges).inset(14)
            make.height.equalTo(24)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(chatView.snp.centerY)
            make.leading.equalTo(chatTextView.snp.trailing).offset(10)
            make.trailing.equalTo(chatView.snp.trailing).inset(14)
            make.height.width.equalTo(20)
        }
    }
}

extension ChattingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = vm.tasks[indexPath.row]
        
        if data.from == UserDefaults.uid {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier) as? MyChatTableViewCell else { return UITableViewCell() }
            
            cell.myChatViewLabel.text = data.chat
            cell.myChatTimeLabel.text = data.createdAt.toDate.chatDate
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherUserChatTableViewCell.reuseIdentifier) as? OtherUserChatTableViewCell else { return UITableViewCell() }
            
            cell.otherUserChatLabel.text = data.chat
            cell.otherUserChatTimeLabel.text = data.createdAt.toDate.chatDate
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.tasks.count
    }
}

extension ChattingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        guard estimatedSize.height < 73 else { return }
        
        // MARK: 텍스트필드는 잘 늘어나고 줄어드는데, 변경된 높이에 따라 테이블뷰가 올라가진 않음ㅜㅜ
        
        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
