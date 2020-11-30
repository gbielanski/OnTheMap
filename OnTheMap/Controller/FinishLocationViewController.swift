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
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var location: CLLocation?
  var link: String?
  var mapString: String?

  @IBAction func finishButtonTapped(){
    let body = StudentLocationRequest(
      uniqueKey: Auth.key,
      firstName: Auth.firstName,
      lastName: Auth.lastName,
      mapString: self.mapString ?? "",
      mediaURL: self.link ?? "",
      latitude: location?.coordinate.latitude ?? 0.0,
      longitude: location?.coordinate.longitude ?? 0.0
    )

    setProcessing(true)
    UdacityClient.postStudentLocations(body: body){
      (success, error) in
      self.setProcessing(false)
      if let error = error {
        DispatchQueue.main.async {
          self.showFailure(message: error.localizedDescription)
        }
      }
    }
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
    setProcessing(true)
    geocoder.reverseGeocodeLocation (location!, completionHandler: { (placemarks, error) in
      self.setProcessing(false)
      if let error = error {
        self.showFailure(message: error.localizedDescription)
        return
      }
      
      let firstLocation = placemarks?[0]
      
      if firstLocation == nil {
        self.showFailure(message: "Cannot find location to show")
        return
      }

      self.mapString = "\(firstLocation?.subLocality?.description ?? "Unknown"), \(firstLocation?.administrativeArea?.description ?? "Unknown"), \(firstLocation?.isoCountryCode! ?? "Unknown")"
      annotation.title = self.mapString
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

  private func setProcessing(_ login: Bool){
    DispatchQueue.main.async {
      if login {
        self.activityIndicator.startAnimating()
      }else{
        self.activityIndicator.stopAnimating()
      }
    }
  }
}
