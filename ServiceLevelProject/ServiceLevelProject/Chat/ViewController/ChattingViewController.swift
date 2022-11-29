//
//  ChattingViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa

final class ChattingViewController: UIViewController {
    let disposeBag = DisposeBag()
    let vm = ChattingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {
        
    }
    
    private func setConfigure() {
        
    }
    
    private func setConstraints() {
        
    }
}
