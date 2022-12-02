//
//  ShopSesacViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/02.
//

import UIKit

final class SesacShopViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - (16 * 3)) / 2
        let spacing: CGFloat = 16
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.estimatedItemSize = CGSize(width: width, height: width * 2)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SesacShopCollectionViewCell.self, forCellWithReuseIdentifier: SesacShopCollectionViewCell.reuseIdentifier)
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

extension SesacShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SeSACFace.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacShopCollectionViewCell.reuseIdentifier, for: indexPath) as? SesacShopCollectionViewCell else { return UICollectionViewCell() }

        cell.sesacImageView.image = SeSACFace(rawValue: indexPath.row)?.image
        
        return cell
    }
}
