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

  override func viewDidLoad() {
    super.viewDidLoad()

    updateMap()
    centerMap()
  }

  private func updateMap() {
    var annotations = [MKPointAnnotation]()
    let annotation = MKPointAnnotation()
    annotation.coordinate = location!.coordinate
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation (location!, completionHandler: { (placemarks, error) in
      let firstLocation = placemarks?[0]

      annotation.title = "\(firstLocation!.subLocality!.description), \(firstLocation!.administrativeArea!.description), \(firstLocation!.isoCountryCode!)"
      annotations.append(annotation)
      self.mapView.addAnnotations(annotations)
    })
  }

  private func centerMap() {
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: location!.coordinate, span: span)
    mapView.setRegion(region, animated: false)
  }
}
