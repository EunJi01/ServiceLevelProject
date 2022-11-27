//
//  NearbyViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/27.
//

import UIKit

class NearbyViewController: SearchResultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        super.tableView.delegate = self
        super.tableView.dataSource = self
    }
}

extension NearbyViewController: UITableViewDataSource, UITableViewDelegate {
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