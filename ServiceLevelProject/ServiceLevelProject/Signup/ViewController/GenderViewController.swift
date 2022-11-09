//
//  GenderViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

final class GenderViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    private let vm = GenderViewModel()

    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.gender))
    private lazy var subTitleLabel: UILabel = customTitleLabel(size: 16, text: .setText(.genderSub))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
}
