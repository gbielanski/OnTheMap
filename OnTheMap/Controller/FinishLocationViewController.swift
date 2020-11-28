//
//  FinishLocationViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 27/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import MapKit

class FinishLocationViewController: UIViewController, MKMapViewDelegate {
  @IBOutlet weak var mapView: MKMapView!
  var location: CLLocation?
  var link: String?
  
  @IBAction func finishButtonTapped(){
    print("finish button tapped")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateMap()
    centerMap()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    print("mapView")
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.pinTintColor = .red
      pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    else {
      pinView!.annotation = annotation
    }
    
    return pinView
  }
  
  private func updateMap() {
    var annotations = [MKPointAnnotation]()
    let annotation = MKPointAnnotation()
    annotation.coordinate = location!.coordinate
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation (location!, completionHandler: { (placemarks, error) in
      if let error = error {
        self.showFailure(message: error.localizedDescription)
        return
      }
      
      let firstLocation = placemarks?[0]
      
      if firstLocation == nil {
        self.showFailure(message: "Cannot find location to show")
        return
      }
      
      annotation.title = "\(firstLocation?.subLocality?.description ?? "Unknown"), \(firstLocation?.administrativeArea?.description ?? "Unknown"), \(firstLocation?.isoCountryCode! ?? "Unknown")"
      annotations.append(annotation)
      self.mapView.addAnnotations(annotations)
    })
  }
  
  private func centerMap() {
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: location!.coordinate, span: span)
    mapView.setRegion(region, animated: false)
  }
  
  private func showFailure(message: String) {
    let alertVC = UIAlertController(title: "Finish Location Failed", message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }
}
