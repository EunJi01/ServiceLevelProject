//
//  HomeViewController.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/14.
//

import UIKit
import MapKit

final class HomeViewController: UIViewController {
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    var center: CLLocationCoordinate2D?
    var recommendedStudy: [String] = []
    var nearbyStudy: [String] = []
    
    private let statusButton: UIButton = {
        let view = UIButton()
        view.tintColor = .white
        view.backgroundColor = .black
        view.layer.cornerRadius = 32
        // MARK: 버튼 사이즈 키워야함
        return view
    }()
    
    private let allButton: UIButton = {
        let view = UIButton()
        view.setTitle("전체", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .setColor(.green)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let manButton: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .white
        return view
    }()
    
    private let womanButton: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14)
        view.backgroundColor = .white
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let gpsButton: UIButton = {
        let view = UIButton()
        view.tintColor = .black
        view.setImage(.setImage(.gps), for: .normal)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let centerImageView: UIImageView = {
        let view = UIImageView()
        view.image = .setImage(.mapMarker)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mapView.delegate = self
        locationManager.delegate = self
        
        let campus = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegion(center: campus)
        locationManager.requestWhenInUseAuthorization() // 왜 직접 호출해야 하지?
        
        setConfigure()
        setConstraints()
        
        statusButton.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateState()
    }

    private func updateState() {
        APIManager.shared.sesac(type: State.self, endpoint: .myQueueState) { [weak self] response in
            switch response {
                
            case .success(let state):
                if state.matched == 0 {
                    self?.statusButton.setImage(myState.matching.buttonImage, for: .normal)
                } else {
                    self?.statusButton.setImage(myState.matched.buttonImage, for: .normal)
                }
                
            case .failure(let statusCode):
                switch statusCode {
                case .alreadySigned:
                    self?.statusButton.setImage(myState.normal.buttonImage, for: .normal)
                default:
                    self?.view.makeToast(statusCode.errorDescription, position: .top)
                }
            }
        }
    }
    
    @objc func statusButtonTapped() {
        APIManager.shared.sesac(type: State.self, endpoint: .myQueueState) { [weak self] response in
            switch response {
                
            case .success(let state):
                if state.matched == 0 {
                    self?.pushSearchResultView()
                } else {
                    self?.pushChattingView()
                }
                
            case .failure(let statusCode):
                switch statusCode {
                case .alreadySigned:
                    self?.pushStudySearchView()
                default:
                    self?.view.makeToast(statusCode.errorDescription, position: .top)
                }
            }
        }
    }
    
    private func pushStudySearchView() {
        let vc = StudySearchViewController()
        vc.vm.center = center
        vc.vm.recommendedStudy = recommendedStudy
        vc.vm.nearbyStudy = nearbyStudy.uniqued()
        transition(vc, transitionStyle: .push)
    }
    
    private func pushSearchResultView() {
        let vc = SearchTabmanViewController()
        vc.center = center
        transition(vc, transitionStyle: .push)
    }
    
    private func pushChattingView() {
        let vc = ChattingViewController()
        transition(vc, transitionStyle: .push)
    }

    private func setConfigure() {
        [mapView, statusButton, allButton, manButton, womanButton, gpsButton, centerImageView].forEach {
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
        
        centerImageView.snp.makeConstraints { make in
            make.center.equalTo(mapView.snp.center)
            make.height.equalTo(45.33)
            make.width.equalTo(34.67)
        }
    }

    func searchSesac(center: CLLocationCoordinate2D) {
        print("searchSesac API 통신")
        APIManager.shared.sesac(type: SearchSesac.self, endpoint: .queueSearch(lat: center.latitude, long: center.longitude)) { [weak self] response in
            switch response {
            case .success(let sesac):
                self?.recommendedStudy = sesac.fromRecommend
                self?.nearbyStudy = []
                for sesac in sesac.fromQueueDB {
                    let location = CLLocationCoordinate2D(latitude: sesac.lat, longitude: sesac.long)
                    self?.nearbyStudy.append(contentsOf: sesac.studylist.filter { $0 != "" && $0 != "anything" })
                    self?.setSesacPin(sesac_image: sesac.sesac, center: location)
                }
                
            case .failure(let statusCode):
                self?.view.makeToast(statusCode.errorDescription, position: .center)
            }
        }
    }
}

extension HomeViewController {
    private func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
    private func setSesacPin(sesac_image: Int, center: CLLocationCoordinate2D) {
       let pin = CustomAnnotation(sesac_image: sesac_image, coordinate: center)
        mapView.addAnnotation(pin)
    }

    private func showRequestLocationServiceAlert() {
        showAlert(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", button: "설정으로 이동") { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
              if CLLocationManager.locationServicesEnabled() {
                  self.locationManager(self.locationManager, didChangeAuthorization: authorizationStatus)
              } else {
                  self.showRequestLocationServiceAlert()
              }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .notDetermined:
             print("GPS 권한 미설정")
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.requestWhenInUseAuthorization()
         case .authorizedAlways, .authorizedWhenInUse:
             print("GPS 권한 허용됨")
             self.locationManager.startUpdatingLocation()
         case .denied, .restricted:
             print("GPS 권한 거부됨 - 아이폰 설정으로 유도")
         default:
             print("GPS: Default")
         }
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print("위치 받아옴")
            setRegion(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 정보 받아오지 못함 - \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization")
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.centerCoordinate
        searchSesac(center: mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }

        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
        } else {
            annotationView?.annotation = annotation
        }
        
        guard let sesacNumber = annotation.sesac_image else { return nil }
        guard let sesacImage = SeSACFace(rawValue: sesacNumber)?.image else { return nil }
        
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
}

extension HomeViewController {
    enum myState {
        case normal
        case matching
        case matched
        
        var buttonImage: UIImage? {
            switch self {
            case .normal:
                return IconSet.search
            case .matching:
                return IconSet.explore
            case .matched:
                return IconSet.massage
            }
        }
    }
}
