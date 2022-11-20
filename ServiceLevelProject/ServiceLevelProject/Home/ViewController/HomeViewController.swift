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
        view.tintColor = .white
        view.backgroundColor = .black
        view.layer.cornerRadius = 32
        view.setImage(IconSet.search, for: .normal)
        // MARK: 버튼 사이즈 키워야함
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
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        setConfigure()
        setConstraints()
        statusButtonTapped()
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
    
    func statusButtonTapped() {
        // 현재 위치 받아와서 Study 쪽으로 넘기며 푸시?
        // let lat = coordinate.latitude
        // let lon = coordinate.longitude
        
        // addCustomPin(sesac_image: 1, center: coordinate)
        transition(StudySearchViewController(), transitionStyle: .push)
    }
}

extension HomeViewController {
    private func setRegion(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mapView.setRegion(region, animated: true)
        currentAnnotation.coordinate = center
        mapView.addAnnotation(currentAnnotation)
    }
    
    private func setCurrentAnnotation(center: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = center
        mapView.addAnnotation(pin)
    }
    
    private func setSesacPin(sesac_image: Int, center: CLLocationCoordinate2D) {
       let pin = CustomAnnotation(sesac_image: sesac_image, coordinate: center)
        mapView.addAnnotation(pin)
    }
    
    private func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
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
             setRegion(center: campus)
             setCurrentAnnotation(center: campus)
             getLocationUsagePermission()
         default:
             print("GPS: Default")
         }
     }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            print("위치 받아옴")
            setRegion(center: coordinate)
            setCurrentAnnotation(center: coordinate)
        }

        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("사용자 위치를 불러오지 못했습니다.")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
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
