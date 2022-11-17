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
    let locationManager = CLLocationManager()
    let currentAnnotation = MKPointAnnotation()
    
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
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
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

extension HomeViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        DispatchQueue.global().async { [weak self] in
              if CLLocationManager.locationServicesEnabled() {
                  guard let self = self else { return }
                  self.locationManager(self.locationManager, didChangeAuthorization: authorizationStatus)
              } else {
                  self?.showRequestLocationServiceAlert()
              }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .authorizedAlways, .authorizedWhenInUse:
             print("GPS 권한 설정됨")
             self.locationManager.startUpdatingLocation()
         case .restricted, .notDetermined:
             print("GPS 권한 설정되지 않음")
             getLocationUsagePermission()
         case .denied:
             print("GPS 권한 요청 거부됨")
             let campus = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
             setRegionAndAnnotation(center: campus)
             getLocationUsagePermission()
         default:
             print("GPS: Default")
         }
     }
    
    func showRequestLocationServiceAlert() {
        showAlert(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", button: "설정으로 이동") { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
        currentAnnotation.coordinate = center
        mapView.addAnnotation(currentAnnotation)
    }
    
    func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            print("위치 받아옴")
            setRegionAndAnnotation(center: coordinate)
        }

        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("사용자 위치를 불러오지 못했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}
