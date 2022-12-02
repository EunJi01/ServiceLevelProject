//
//  OnboardingViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/07.
//

import UIKit
import RxSwift
import RxCocoa

final class OnboardingPageViewController: UIViewController, CustomView {
    
    private lazy var startButton: UIButton = customButton(title: "시작하기", backgroundColor: .green)
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pageViewControllerList: [UIViewController] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        bind()
        setConfigure()
        setConstraints()
        createPageViewController()
        configurePageViewController()
    }
    
    private func bind() {
        startButton.rx.tap
            .bind { [weak self] _ in
                UserDefaults.showOnboarding = false
                self?.transition(LoginViewController(), transitionStyle: .presentFullNavigation)
            }
            .disposed(by: disposeBag)
    }
    
    private func setConfigure() {
        [startButton, pageViewController.view].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(pageViewController.view.snp.bottom).offset(42)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func createPageViewController() {
        let first = OnboardingViewController()
        let second = OnboardingViewController()
        let third = OnboardingViewController()
        
        first.mainImageView.image = .setImage(.onboardingImg1)
        second.mainImageView.image = .setImage(.onboardingImg2)
        third.mainImageView.image = .setImage(.onboardingImg3)
        
        first.titleLabel.text = .setText(.onboardingText1)
        second.titleLabel.text = .setText(.onboardingText2)
        third.titleLabel.text = .setText(.onboardingText3)
        
        first.titleLabel.asColor(targetString: "위치 기반", color: .green)
        second.titleLabel.asColor(targetString: "스터디를 원하는 친구", color: .green)
        
        pageViewControllerList = [first, second, third]
    }
    
    private func configurePageViewController() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.systemGray
        appearance.currentPageIndicatorTintColor = UIColor.black
        
        guard let first = pageViewControllerList.first else { return }
        pageViewController.setViewControllers([first], direction: .forward, animated: true)
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = pageViewController.viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        return index
    }
}
