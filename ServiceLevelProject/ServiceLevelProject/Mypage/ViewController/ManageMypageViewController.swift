//
//  ManageMypageViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit
import RxSwift
import RxCocoa
import DoubleSlider

final class ManageMypageViewController: UIViewController, CustomView {
    private let disposeBag = DisposeBag()
    
    private let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: ManageMypageViewController.self, action: nil)
    
    private lazy var myGenderLabel: UILabel = customTitleLabel(size: 14, text: "내 성별")
    private lazy var studyLabel: UILabel = customTitleLabel(size: 14, text: "자주 하는 스터디")
    private lazy var searchForNumbersLabel: UILabel = customTitleLabel(size: 14, text: "내 번호 검색 허용")
    private lazy var ageGroupLabel: UILabel = customTitleLabel(size: 14, text: "상대방 연령대")
    private lazy var withdrawLabel: UILabel = customTitleLabel(size: 14, text: "회원탈퇴")
    
    private lazy var manButton: UIButton = customButton(title: "남자")
    private lazy var womanButton: UIButton = customButton(title: "여자")
    private lazy var studyTextField: UITextField = customTextField(placeholder: "스터디를 입력해 주세요")
    private lazy var underline: UIView = customUnderlineView()
    private let searchForNumbersSwitch = UISwitch()
    private let ageGroupSlider = UISlider()
    private lazy var ageRangeLabel = customTitleLabel(size: 14, text: "임시")

    private let imageView = UIImageView()
    private lazy var cardView = customCardView()
    private let myGenderView = UIView()
    private let studyView = UIView()
    private let searchForNumbersView = UIView()
    private let ageGroupView = UIView()
    private let withdrawView = UIView()
    
    private lazy var viewList = [myGenderView, studyView, searchForNumbersView, ageGroupView, withdrawView]
    private lazy var labelList = [myGenderLabel, studyLabel, searchForNumbersLabel, ageGroupLabel, withdrawLabel]
    private let scrollView = UIScrollView()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: viewList)
        view.axis = .vertical
        view.distribution = .fillProportionally
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = saveButton
        
        bind()
        setProperties()
        setConfigure()
        setConstraints()
    }
    
    private func bind() {

    }
    
    private func setProperties() {
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 10
        
        ageRangeLabel.textColor = .setColor(.green)
        searchForNumbersSwitch.tintColor = .setColor(.green)
        ageGroupSlider.tintColor = .setColor(.green)
        
        womanButton.backgroundColor = .white
        womanButton.setTitleColor(.black, for: .normal)
        womanButton.layer.borderColor = UIColor.setColor(.gray3).cgColor
        womanButton.layer.borderWidth = 1
        
        manButton.backgroundColor = .white
        manButton.setTitleColor(.black, for: .normal)
        manButton.layer.borderColor = UIColor.setColor(.gray3).cgColor
        manButton.layer.borderWidth = 1
    }
    
    private func setConfigure() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(stackView)

        [myGenderLabel, manButton, womanButton].forEach {
            myGenderView.addSubview($0)
        }
        
        [studyLabel, studyTextField, underline].forEach {
            studyView.addSubview($0)
        }
        
        [searchForNumbersLabel, searchForNumbersSwitch].forEach {
            searchForNumbersView.addSubview($0)
        }
        
        [ageGroupLabel, ageGroupSlider, ageRangeLabel].forEach {
            ageGroupView.addSubview($0)
        }
        
        withdrawView.addSubview(withdrawLabel)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(scrollView.snp.width).multipliedBy(0.5)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        for label in labelList {
            guard label != ageGroupLabel else { continue }
            label.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview().inset(30)
            }
        }
        
        womanButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.width.equalTo(56)
            make.centerY.equalToSuperview()
        }
        
        manButton.snp.makeConstraints { make in
            make.trailing.equalTo(womanButton.snp.leading).offset(-8)
            make.size.equalTo(womanButton)
            make.centerY.equalToSuperview()
        }
        
        studyTextField.snp.makeConstraints { make in
            make.centerX.equalTo(underline.snp.centerX)
            make.width.equalTo(136)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        underline.snp.makeConstraints { make in
            make.top.equalTo(studyTextField.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(164)
            make.height.equalTo(1)
        }
        
        searchForNumbersSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        ageGroupLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        ageRangeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageGroupLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
        
        ageGroupSlider.snp.makeConstraints { make in
            make.top.equalTo(ageRangeLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
