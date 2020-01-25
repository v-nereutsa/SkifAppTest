//
//  ViewInputProtocol.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation
import MapKit

protocol ViewInputProtocol {
    func animateToNextCoordinate(coordinate: CLLocationCoordinate2D)
    func addPolylineOverlay(polyline: MKPolyline)
    func updateSpeed(speed: String)
    func setRegion(coordinate: CLLocationCoordinate2D)
    func setCarAnnotation(coordinate: CLLocationCoordinate2D)
    func dismiss()
    func showError(message: String)
    func okAlert(title: String, message: String)
    func updateButton(flag: Bool)
}
