//
//  StudySearchViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/18.
//

import UIKit

class StudySearchViewController: UIViewController, CustomView {

    private let collectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(StudySearchCollectionViewCell.self, forCellWithReuseIdentifier: StudySearchCollectionViewCell.reuseIdentifier)
        if let flowLayout = view.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
        return view
    }()
    
    private let searchBar: UISearchBar = {
        var width = UIScreen.main.bounds.size.width
        let view = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 12, height: 0))
        view.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        view.searchTextField.font = .systemFont(ofSize: 14)
        return view
    }()
    
    private lazy var searchButton: UIButton = customButton(title: "새싹 찾기")
    
    let dummy = ["스위프트", "파이썬", "알고리즘", "가나다라마바사아자차카타파하", "ㅎ하하하ㅏ하du"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        setConfigure()
        setConstraints()
    }
    
    private func setConfigure() {
        searchButton.backgroundColor = .setColor(.green)
        
        [collectionView, searchButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}

extension StudySearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudySearchCollectionViewCell.reuseIdentifier, for: indexPath) as? StudySearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.studyLabel.text = dummy[indexPath.row]
        
        return cell
    }
}
