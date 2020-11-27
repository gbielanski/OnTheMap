//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 26/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = UdacityClient.getStudentLocations { students, error in
      StudentModel.studentlist = students
      self.updateMap()
      self.centerMap()
    }
  }
  
  private func centerMap() {
    let centerLocation = CLLocation(
      latitude: CLLocationDegrees(StudentModel.studentlist[0].latitude),
      longitude: CLLocationDegrees(StudentModel.studentlist[0].longitude))
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: centerLocation.coordinate, span: span)
    mapView.setRegion(region, animated: false)
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
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    print("mapVIewTapped")
    if control == view.rightCalloutAccessoryView {
      let app = UIApplication.shared
      if let toOpen = view.annotation?.subtitle! {
        app.open(URL(string: toOpen)!)
      }
    }
  }
  
  private func updateMap(){
    var annotations = [MKPointAnnotation]()
    
    for student in StudentModel.studentlist {
      
      let lat = CLLocationDegrees(student.latitude)
      let long = CLLocationDegrees(student.longitude)
      
      let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = "\(student.firstName.notEmptyString()) \(student.lastName.notEmptyString())"
      annotation.subtitle = student.mediaURL.withUrlSchema()
      
      annotations.append(annotation)
    }
    
    self.mapView.addAnnotations(annotations)
  }

  @IBAction func refresh(){
    setResfreshing(true)
    _ = UdacityClient.getStudentLocations { students, error in
      StudentModel.studentlist = students
      self.updateMap()
      self.setResfreshing(false)
    }
  }

  private func setResfreshing(_ login: Bool){
    if login {
      activityIndicator.startAnimating()
    }else{
      activityIndicator.stopAnimating()
    }
  }
  
}

