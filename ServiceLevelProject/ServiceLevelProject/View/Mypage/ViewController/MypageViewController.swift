//
//  MyInfoViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/13.
//

import UIKit

final class MypageViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(MypageTableViewCell.self, forCellReuseIdentifier: MypageTableViewCell.reuseIdentifier)
        view.register(MypageNicknameTableViewCell.self, forCellReuseIdentifier: MypageNicknameTableViewCell.reuseIdentifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "내정보"
        
        setConfigure()
        setConstraints()
    }
    
    private func setConfigure() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MypageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : Mypage.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageNicknameTableViewCell.reuseIdentifier) as? MypageNicknameTableViewCell else { return UITableViewCell() }
            
            cell.nicknameLabel.text = UserDefaults.userNickname
            cell.profileImageView.image = SeSACFace(rawValue: UserDefaults.sesacNumber)?.image
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageTableViewCell.reuseIdentifier) as? MypageTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = Mypage.allCases[indexPath.row].title
            cell.iconImageView.image = Mypage.allCases[indexPath.row].icon
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            transition(ManageMypageViewController(), transitionStyle: .push)
        }
    }
}
