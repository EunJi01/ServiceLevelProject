//
//  CustomAnnotation.swift
//  ServiceLevelProject
//
//  Created by 황은지 on 2022/11/18.
//

import UIKit
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    static let identifier = "CustomAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}

final class CustomAnnotation: NSObject, MKAnnotation {
  let sesac_image: Int?
  let coordinate: CLLocationCoordinate2D

  init(sesac_image: Int?, coordinate: CLLocationCoordinate2D) {
    self.sesac_image = sesac_image
    self.coordinate = coordinate

    super.init()
  }
}
