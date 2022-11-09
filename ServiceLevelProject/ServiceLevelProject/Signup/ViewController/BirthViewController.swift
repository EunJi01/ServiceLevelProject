//
//  BirthViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/09.
//

import UIKit
import RxSwift
import RxCocoa

final class BirthViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    
    private lazy var titleLabel: UILabel = customTitleLabel(size: 20, text: .setText(.birth))
    private lazy var nextButton: UIButton = customButton(title: "다음")
    private lazy var underlineView: UIView = customUnderlineView()
    private lazy var textField: UITextField = customTextField(placeholder: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textField.becomeFirstResponder()
        
    }
}
