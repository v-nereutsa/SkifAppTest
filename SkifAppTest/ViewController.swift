//
//  ViewController.swift
//  SkifAppTest
//
//  Created by Владимир Нереуца on 23.01.2020.
//  Copyright © 2020 Владимир Нереуца. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    
    var viewModel: ViewModelProtocol = ViewModel()
    var carAnnotation = MKPointAnnotation()
    
    var animationDuration: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad(viewController: self)
        map.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingAlert()
    }
    
    @IBAction func startMoving(_ sender: Any) {
        viewModel.onButtonClicked()
    }
}

extension ViewController: ViewInputProtocol {
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: { [weak self] in
                self?.okAlert(title: "Error", message: message)
            })
        }
    }
    
    func updateSpeed(speed: String) {
        speedLabel.text = "Speed: \(speed) km/h"
    }
    
    func setCarAnnotation(coordinate: CLLocationCoordinate2D) {
        animationDuration = viewModel.getAnimationTime()
        carAnnotation.title = "Driver"
        carAnnotation.coordinate = coordinate
        DispatchQueue.main.async {
            self.map.addAnnotation(self.carAnnotation)
        }
    }
    
    func addPolylineOverlay(polyline: MKPolyline) {
        DispatchQueue.main.async {
            self.map.addOverlay(polyline)
        }
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: .init(latitude: coordinate.latitude, longitude: coordinate.longitude), span: span)
        DispatchQueue.main.async {
            self.map.setRegion(region, animated: true)
        }
    }
    
    func animateToNextCoordinate(coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: animationDuration ?? 0.1, animations: {
            self.carAnnotation.coordinate = coordinate
        }, completion:  { _ in
            self.viewModel.coordinateIndex += 1
        })
    }
    
    func updateButton(flag: Bool) {
        if flag {
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = .green
        } else {
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = .red
        }
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = UIColor.yellow.withAlphaComponent(0.5)
            polylineRender.lineWidth = 1
            return polylineRender
        }
        return MKOverlayRenderer()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let title = annotation.title, title == "Driver" {
            annotationView?.image = UIImage(named: "car")
        }
        
        return annotationView
    }
    
}

extension ViewController {
    
    func okAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func loadingAlert() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
