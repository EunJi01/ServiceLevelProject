//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    let mapView = MKMapView()
    
    let statusButton: UIButton = {
        let view = UIButton()
        view.tintColor = .black
        view.backgroundColor = .black
        view.layer.cornerRadius = 32
        return view
    }()
    
    let allButton: UIButton = {
        let view = UIButton()
        view.setTitle("전체", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        return view
    }()
    
    let manButton: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .white
        return view
    }()
    
    let womanButton: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 10
        return view
    }()
    
    let gpsButton: UIButton = {
        let view = UIButton()
        view.tintColor = .black
        view.setImage(.setImage(.gps), for: .normal)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()

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
        [mapView, statusButton, allButton, manButton, womanButton, gpsButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        statusButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(64)
        }
        
        allButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(54)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(48)
        }
        
        manButton.snp.makeConstraints { make in
            make.top.equalTo(allButton.snp.bottom)
            make.horizontalEdges.equalTo(allButton.snp.horizontalEdges)
            make.height.equalTo(allButton.snp.height)
        }
        
        womanButton.snp.makeConstraints { make in
            make.top.equalTo(manButton.snp.bottom)
            make.horizontalEdges.equalTo(allButton.snp.horizontalEdges)
            make.height.equalTo(allButton.snp.height)
        }
        
        gpsButton.snp.makeConstraints { make in
            make.top.equalTo(womanButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(allButton.snp.horizontalEdges)
            make.height.equalTo(allButton.snp.height)
        }
    }
}
