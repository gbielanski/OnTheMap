//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 26/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = UdacityClient.getStudentLocations { students, error in
      StudentModel.studentlist = students
      self.updateMap()
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

}

