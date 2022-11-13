//
//  LaunchViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/13.
//

import UIKit

class LaunchViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let titleImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setConfigure()
        setConstraints()
        viewTransition()
    }
    
    private func viewTransition() {
        guard networkCheck() else { return }
        var vc: UIViewController?
        
        APIManager.shared.get(type: UserInfo.self, endpoint: .login) { [weak self] statusCode in
            if UserDefaults.showOnboarding {
                vc = OnboardingPageViewController()
            } else {
                switch statusCode {
                case .success:
                    vc = MainTabBarController()
                case .mustSignup:
                    if UserDefaults.authenticationCompleted {
                        vc = NicknameViewController()
                    } else {
                        vc = LoginViewController()
                    }
                default:
                    vc = LoginViewController()
                }
            }
        
            guard let vc = vc else { return }
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }
    }
    
    private func setConfigure() {
        logoImageView.image = .setImage(.splashLogo)
        titleImageView.image = .setImage(.splashTitle)
        
        [logoImageView, titleImageView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(264)
            make.width.equalTo(220)
        }
        
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.height.equalTo(101)
            make.width.equalTo(292)
        }
    }
}
