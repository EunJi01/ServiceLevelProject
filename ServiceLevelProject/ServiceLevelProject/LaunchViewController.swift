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
        
        networkCheck { [weak self] isConnected in
            // MARK: 분명 전에는 됐는데ㅠㅠㅠ 네트워크 연결 실패했을 때 얼럿이 안뜬다...
            guard isConnected == true else { return }
            self?.getIdToken()
        }
    }
    
    private func getIdToken() {
        FirebaseAuth.shared.getIDToken { [weak self] error in
            if error != nil {
                self?.viewTransition()
            } else {
                self?.view.makeToast(APIStatusCode.firebaseTokenError.errorDescription, position: .top)
            }
        }
    }
    
    private func viewTransition() {
        APIManager.shared.get(type: UserInfo.self, endpoint: .login) { [weak self] statusCode in
            if UserDefaults.showOnboarding {
                self?.transition(OnboardingPageViewController(), transitionStyle: .presentFull)
            } else {
                switch statusCode {
                case .success:
                    self?.transition(MainTabBarController(), transitionStyle: .presentFull)
                case .mustSignup:
                    if UserDefaults.authenticationCompleted {
                        self?.transition(NicknameViewController(), transitionStyle: .presentFullNavigation)
                    } else {
                        self?.transition(LoginViewController(), transitionStyle: .presentFullNavigation)
                    }
                case.firebaseTokenError:
                    print("이 로그는 절대 뜨면 안됨")
                default:
                    self?.transition(LoginViewController(), transitionStyle: .presentFullNavigation)
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
