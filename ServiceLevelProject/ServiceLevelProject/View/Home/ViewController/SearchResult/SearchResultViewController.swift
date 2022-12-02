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

    private lazy var changeStudyButton: UIButton = customButton(title: "스터디 변경하기", backgroundColor: .green)
    
    let nodataView = UIView()
    lazy var nodataTitleLabel: UILabel = customTitleLabel(size: 20, text: "아쉽게도 주변에 새싹이 없어요ㅠ")
    lazy var nodataSubLabel: UILabel = customTitleLabel(size: 14, text: "스터디를 변경하거나 조금만 더 기다려 주세요!")
    
    private let nodataImageView: UIImageView = {
        let view = UIImageView()
        view.image = .setImage(.sesacNodata)
        return view
    }()
    
    private let refreshButton: UIButton = {
        let view = UIButton()
        view.setImage(IconSet.refresh, for: .normal)
        view.layer.borderColor = UIColor.setColor(.green).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.tintColor = .setColor(.green)
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        view.separatorStyle = .none
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nodataSubLabel.textColor = .setColor(.gray7)
        nodataView.isHidden = true
        
        bind()
        setConfigure()
        setConstraints()
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
        
        output.popVC
            .withUnretained(self)
            .emit { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        [tableView, changeStudyButton, refreshButton, nodataView].forEach {
            view.addSubview($0)
        }
        
        [nodataImageView, nodataTitleLabel, nodataSubLabel].forEach {
            nodataView.addSubview($0)
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
        
        nodataView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.85)
            make.height.width.equalTo(64)
        }
        
        nodataImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        nodataTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nodataImageView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
        }
        
        nodataSubLabel.snp.makeConstraints { make in
            make.top.equalTo(nodataTitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
