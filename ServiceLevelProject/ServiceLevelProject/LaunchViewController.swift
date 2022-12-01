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
        
        networkCheck { [weak self] isConnected in
            // MARK: 분명 전에는 됐는데ㅠㅠㅠ 네트워크 연결 실패했을 때 얼럿이 안뜬다...
            guard isConnected == true else { return }
            self?.viewTransition()
        }
    }
    
    private func viewTransition() {
        APIManager.shared.sesac(type: UserInfo.self, endpoint: .login) { [weak self] response in
            switch response {
            case .success(let userInfo):
                // MARK: FCM 토큰 서버와 비교하고 업데이트하는 로직 필요!
                UserDefaults.uid = "uYK05HR3jzctuiQBAnaH5eicgkv1" // MARK: 임시!!!! 로그인 시/회원가입 시 저장하면 될듯?
                print("==id token== \(UserDefaults.idToken)")
                UserDefaults.userNickname = userInfo.nick
                UserDefaults.sesacNumber = userInfo.sesac
                self?.transition(MainTabBarController(), transitionStyle: .presentFull)
                
            case .failure(let statusCode):
                switch statusCode {
                case .firebaseTokenError:
                    FirebaseAuth.shared.getIDToken { error in
                        if error == nil {
                            self?.viewTransition()
                        } else {
                            self?.view.makeToast(statusCode.errorDescription, position: .top)
                        }
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
