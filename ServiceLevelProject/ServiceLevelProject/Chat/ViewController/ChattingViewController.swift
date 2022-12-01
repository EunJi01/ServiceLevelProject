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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        let input = ChattingViewModel.Input(
            sendButton: sendButton.rx.tap
                .withLatestFrom(chatTextView.rx.text.orEmpty)
                .asSignal(onErrorJustReturn: ""),
            chatTextView: chatTextView.rx.text.orEmpty.asSignal(onErrorJustReturn: "")
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
        //if data.userID == UserDefaults.uid {
        if indexPath.row.isMultiple(of: 2) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reuseIdentifier) as? MyChatTableViewCell else { return UITableViewCell() }
            
            cell.myChatViewLabel.text = "내거임"
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherUserChatTableViewCell.reuseIdentifier) as? OtherUserChatTableViewCell else { return UITableViewCell() }
            
            cell.otherUserChatLabel.text = "남거임"
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
