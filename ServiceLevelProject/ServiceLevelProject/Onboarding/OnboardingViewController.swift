//
//  FirstOnboardingViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 26)
        // MARK: 행간 조절하기!
        return view
    }()
    
    let mainImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            make.horizontalEdges.equalToSuperview().inset(85)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(80)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(80)
        }
    }
}
