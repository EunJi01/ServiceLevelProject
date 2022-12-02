//
//  BackgroundShopViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/02.
//

import UIKit

final class BackgroundShopViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let spacing: CGFloat = 16
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.estimatedItemSize = CGSize(width: width, height: width)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(BackgroundShopCollectionViewCell.self, forCellWithReuseIdentifier: BackgroundShopCollectionViewCell.reuseIdentifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        
    }
    
    private func setConfigure() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BackgroundShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SeSACBackground.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundShopCollectionViewCell.reuseIdentifier, for: indexPath) as? BackgroundShopCollectionViewCell else { return UICollectionViewCell() }

        cell.backgroundImageView.image = SeSACBackground(rawValue: indexPath.row)?.image
        
        return cell
    }
}
