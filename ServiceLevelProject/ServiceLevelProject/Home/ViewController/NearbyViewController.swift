//
//  NearbyViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class NearbyViewController: SearchResultViewController {
    let nearbyVM = NearbyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        super.tableView.delegate = self
        super.tableView.dataSource = self
        
        bind()
    }
    
    private func bind() {
        let input = NearbyViewModel.Input()
        let output = nearbyVM.transform(input: input)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: super.disposeBag)
    }
}

extension NearbyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkResult()
        return vm.result.fromQueueDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let sesac = vm.result.fromQueueDB[indexPath.row]
        
        cell.backgroundImageView.image = SeSACBackground(rawValue: sesac.background)?.image
        cell.sesacImageView.image = SeSACFace(rawValue: sesac.sesac)?.image
        cell.nicknameLabel.text = sesac.nick
        
        cell.requestButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.showAlert(title: "스터디를 요청할게요", message: "상대방이 요청을 수락하면 채팅방에서 대화를 나눌 수 있어요") { _ in
                    vc.nearbyVM.requestStudy(user: sesac)
                }
            }
            .disposed(by: super.disposeBag)
        
        return cell
    }
}

extension NearbyViewController {
    private func checkResult() {
        if vm.result.fromQueueDB.isEmpty {
            super.nodataView.isHidden = false
        } else {
            super.nodataView.isHidden = true
        }
    }
}
