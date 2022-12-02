//
//  RequestReceivedViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/27.
//

import UIKit
import RxSwift
import RxCocoa

final class RequestReceivedViewController: SearchResultViewController {
    let requestVM = RequestReceivedViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.tableView.delegate = self
        super.tableView.dataSource = self
        
        super.nodataTitleLabel.text = "아직 받은 요청이 없어요ㅠ"

        bind()
    }
    
    private func bind() {
        let input = RequestReceivedViewModel.Input()
        let output = requestVM.transform(input: input)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: super.disposeBag)
        
        output.pushNextVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.transition(ChattingViewController(), transitionStyle: .push)
            }
            .disposed(by: disposeBag)
    }
}

extension RequestReceivedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkResult()
        return vm.result.fromQueueDBRequested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let sesac = vm.result.fromQueueDBRequested[indexPath.row]
        
        cell.cardView.backgroundImageView.image = SeSACBackground(rawValue: sesac.background)?.image
        cell.cardView.sesacImageView.image = SeSACFace(rawValue: sesac.sesac)?.image
        cell.cardView.nicknameLabel.text = sesac.nick
        cell.cardView.button.setTitle("수락하기", for: .normal)
        cell.cardView.button.backgroundColor = .setColor(.success)
        
        cell.cardView.button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.showAlert(title: "스터디를 수락할까요?", message: "요청을 수락하면 채팅방에서 대화를 나눌 수 있어요") { _ in
                    vc.requestVM.acceptStudy(user: sesac)
                }
            }
            .disposed(by: super.disposeBag)
        
        return cell
    }
}

extension RequestReceivedViewController {
    private func checkResult() {
        if vm.result.fromQueueDBRequested.isEmpty {
            super.nodataView.isHidden = false
        } else {
            super.nodataView.isHidden = true
        }
    }
}
