//
//  ShopViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/12/03.
//

import UIKit

final class ShopViewController: UIViewController, CustomView {
    private let cardView = CardView()
    private let containerView = UIView()
    
    private let tabmanVC = ShopTabViewController()
    private let sesacVC = SesacShopViewController()
    private let backgroundVC = BackgroundShopViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.title = "새싹샵"
        
        cardView.nicknameView.isHidden = true
        cardView.backgroundImageView.image = SeSACBackground(rawValue: 1)?.image
        cardView.sesacImageView.image = SeSACFace(rawValue: 1)?.image
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        
    }

    private func setConfigure() {
        cardView.button.isHidden = false
        cardView.button.setTitle("저장하기", for: .normal)
        cardView.button.backgroundColor = .setColor(.green)
        
        [cardView, containerView].forEach {
            view.addSubview($0)
        }

        addChild(tabmanVC)
        tabmanVC.viewControllers = [sesacVC, backgroundVC]
        tabmanVC.view.frame = containerView.frame
        containerView.addSubview(tabmanVC.view)
        tabmanVC.didMove(toParent: self)
    }
    
    private func setConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(cardView.height)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(cardView.backgroundImageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
