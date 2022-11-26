//
//  SearchResultViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/24.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultViewController: UIViewController, CustomView {
    let disposeBag = DisposeBag()
    let vm = SearchResultViewModel()

    private lazy var changeStudyButton: UIButton = customButton(title: "스터디 변경하기")
    
    private let refreshButton: UIButton = {
        let view = UIButton()
        view.setImage(IconSet.refresh, for: .normal)
        view.layer.borderColor = UIColor.setColor(.green).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.tintColor = .setColor(.green)
        return view
    }()
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        view.separatorStyle = .none
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

        guard let center = vm.center else { return }
        vm.searchSesac(center:center)
    }
    
    private func bind() {
        let input = SearchResultViewModel.Input(
            refreshButton: refreshButton.rx.tap.asSignal(),
            changeStudyButton: changeStudyButton.rx.tap.asSignal()
        )
        
        let output = vm.transform(input: input)
        
        output.showToast
            .withUnretained(self)
            .emit { vc, text in
                vc.view.makeToast(text, position: .top)
            }
            .disposed(by: disposeBag)
        
        output.refresh
            .withUnretained(self)
            .emit { vc, _ in
                vc.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        changeStudyButton.backgroundColor = .setColor(.green)
        
        [tableView, changeStudyButton, refreshButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        changeStudyButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-8)
            make.height.equalTo(48)
        }
        refreshButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(refreshButton.snp.top).offset(-16)
        }
    }
}

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.result.fromQueueDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier) as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let sesac = vm.result.fromQueueDB[indexPath.row]
        
        cell.backgroundImageView.image = SeSACBackground(rawValue: sesac.background)?.image
        cell.sesacImageView.image = SeSACFace(rawValue: sesac.sesac)?.image
        cell.nicknameLabel.text = sesac.nick
        
        return cell
    }
}
