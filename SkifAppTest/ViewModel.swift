//
//  ViewModel.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 25.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import Foundation
import MapKit

class ViewModel: ViewModelNetworkOutputProtocol, ViewModelProtocol {
    
    private var isStarted = false
    var locations: [Location] = []
    var viewController: ViewInputProtocol?
    var model: NetworkModelProtocol = NetworkModel()
    
    var coordinateIndex: Int! = 0 {
        didSet {
            guard coordinateIndex != locations.count else {
                viewController?.showOkAlert(title: "Finish", message: "The car reached the finish.")
                return
            }
            if isStarted {
                viewController?.animateToNextCoordinate(coordinate: getMovedCarCoordinate())
            } else {
                viewController?.updateSpeed(speed: getCurrentSpeed())
            }
        }
    }
    
    var avgAnimationTime: Double {
        return 120 / Double(locations.count)
    }
    
    func getAnimationTime() -> Double {
        return avgAnimationTime
    }
    
    func viewDidLoad(viewController: ViewInputProtocol) {
        self.viewController = viewController
        model.getJSONData()
        model.subscribe(viewModel: self)
    }
    
    
    func onDataReceived(data: Locations) {
        locations = data.locations
        let polyline = createPolyline(loc: data)
        let coordinate = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        viewController?.dismiss()
        viewController?.addPolylineOverlay(polyline: polyline)
        viewController?.setCarAnnotation(coordinate: coordinate)
        viewController?.setRegion(coordinate: coordinate)
    }
    
    func onErrorReceived() {
        viewController?.showError(message: "Network or data error.")
    }
    
    func onButtonClicked() {
        viewController?.updateButton(flag: isStarted)
        if isStarted {
            isStarted = false
            viewController?.updateSpeed(speed: getCurrentSpeed())
        } else {
            isStarted = true
            viewController?.animateToNextCoordinate(coordinate: getMovedCarCoordinate())
        }
    }
    
    
    private func getMovedCarCoordinate() -> CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: locations[coordinateIndex].coordinate.latitude, longitude: locations[coordinateIndex].coordinate.longitude)
        return coordinate
    }
    
    
    private func getCurrentSpeed() -> String {
        guard coordinateIndex != 0 else {
            return "0"
        }
        let startCoordinate = CLLocation(latitude: locations[coordinateIndex].coordinate.latitude, longitude: locations[coordinateIndex].coordinate.longitude)
        let finishCoordinate = CLLocation(latitude: locations[coordinateIndex-1].coordinate.latitude, longitude: locations[coordinateIndex-1].coordinate.longitude)
        let distance = startCoordinate.distance(from: finishCoordinate)
        let startTime = locations[coordinateIndex].time
        let finishTime = locations[coordinateIndex-1].time
        let time = startTime.timeIntervalSince(finishTime)
        let speed = Int((distance / time) * 3.6)
        return String(speed)
    }
    
    
    private func createPolyline(loc: Locations) -> MKPolyline {
        var locations: [CLLocationCoordinate2D] = []
        for i in 0..<loc.locations.count-1 {
            if !(loc.locations[i].coordinate.latitude - 0.04  > loc.locations[i+1].coordinate.latitude) &&
                !(loc.locations[i].coordinate.longitude - 0.04 > loc.locations[i+1].coordinate.longitude) {
                locations.append(loc.locations[i].coordinate)
            }
        }
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        return polyline
    }
    
}

