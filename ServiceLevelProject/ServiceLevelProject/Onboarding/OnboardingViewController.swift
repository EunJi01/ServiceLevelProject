//
//  FirstOnboardingViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit

class OnboardingViewController: UIViewController, CustomView {
    
    lazy var titleLabel: UILabel = customTitleLabel(size: 24)
    let mainImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setConfigure()
        setConstraints()
    }
    
    private func setConfigure() {
        [titleLabel, mainImageView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(116)
            make.centerX.equalToSuperview()
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(80)
        }
    }
}
