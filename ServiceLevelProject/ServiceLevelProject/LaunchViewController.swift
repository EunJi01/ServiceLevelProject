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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkCheck { [weak self] isConnected in
            self?.viewTransition()
        }
    }
    
    private func viewTransition() {
        APIManager.shared.sesac(type: UserInfo.self, endpoint: .login) { [weak self] response in
            switch response {
            case .success(let userInfo):
                print("==id token== \(UserDefaults.idToken)")
                
                if userInfo.fcmToken != UserDefaults.fcmToken {
                    self?.updateFCMToken()
                } else {
                    UserDefaults.userNickname = userInfo.nick
                    UserDefaults.sesacNumber = userInfo.sesac
                    self?.transition(MainTabBarController(), transitionStyle: .presentFull)
                }
                
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.viewTransition()
                    }
                case .notRegistered:
                    if UserDefaults.authenticationCompleted {
                        self?.transition(NicknameViewController(), transitionStyle: .presentFullNavigation)
                    } else {
                        self?.transition(LoginViewController(), transitionStyle: .presentFullNavigation)
                    }
                default:
                    if UserDefaults.showOnboarding {
                        self?.transition(OnboardingPageViewController(), transitionStyle: .presentFull)
                    } else {
                        self?.view.makeToast(statusCode.errorDescription, position: .top)
                    }
                }
            }
        }
    }
    
    private func updateFCMToken() {
        APIManager.shared.sesac(endpoint: .updateFCM) { [weak self] response in
            switch response {
            case .success(_):
                self?.viewTransition()
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        guard error == nil else { return }
                        self?.updateFCMToken()
                    }
                default:
                    if UserDefaults.showOnboarding {
                        self?.transition(OnboardingPageViewController(), transitionStyle: .presentFull)
                    } else {
                        self?.view.makeToast(statusCode.errorDescription, position: .top)
                    }
                }
            }
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
