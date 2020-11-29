//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 27/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import MapKit

class FindLocationViewController: UIViewController {
  
  var foundLocation: CLLocation?
  
  @IBOutlet weak var locationTextView: UITextField!
  @IBOutlet weak var linkTextView: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBAction func findLocationButtonTapped(){
    
    guard let link = linkTextView.text, link.count > 0 else {
      self.showFailure(message: "Link cannot be empty")
      return
    }

    guard let location = locationTextView.text, location.count > 0 else {
      self.showFailure(message: "Link cannot be empty")
      return
    }
    
    findLocation(location: location)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "finishLocation" {
      let finishVC = segue.destination as! FinishLocationViewController
      finishVC.location = foundLocation
    }
  }
  
  private func findLocation(location: String){
    setProcessing(true)
    CLGeocoder().geocodeAddressString(location) { (marker, error) in
      self.setProcessing(false)
      if let error = error {
        self.showFailure(message: error.localizedDescription)
      } else {
        var location: CLLocation?
        
        if let marker = marker, marker.count > 0 {
          location = marker.first?.location
        }
        
        if let location = location {
          self.foundLocation = location
          self.performSegue(withIdentifier: "finishLocation", sender: nil)
        } else {
          self.showFailure(message: "Please try again later.")
        }
      }
    }
  }
  
  private func showFailure(message: String) {
    let alertVC = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
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
