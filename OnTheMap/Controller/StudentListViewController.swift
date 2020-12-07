//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 25/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

import UIKit

class StudentListViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.tabBarController?.tabBar.isHidden = false
    tableView.reloadData()
  }

  @IBAction func refresh(){
    updateTable()
  }

  private func setProcessing(_ login: Bool){
    if login {
      activityIndicator.startAnimating()
    }else{
      activityIndicator.stopAnimating()
    }
  }

  @IBAction func logout(_ sender: Any) {
    setProcessing(true)
    UdacityClient.logout{
      (result, error) in
      DispatchQueue.main.async {
        self.setProcessing(false)
        if result {
          self.dismiss(animated: true, completion: nil)
        }else{
          self.showFailure(message: error.debugDescription)
        }
      }
    }
  }
  
  private func showFailure(message: String) {
    let alertVC = UIAlertController(title: "Logout Failed", message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alertVC, animated: true, completion: nil)
  }

  private func updateTable(){
    setProcessing(true)
    _ = UdacityClient.getStudentLocations { students, error in
      StudentModel.studentlist = students

      self.tableView.reloadData()
      self.setProcessing(false)
    }
  }
}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StudentModel.studentlist.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!

    let student = StudentModel.studentlist[indexPath.row]

    cell.textLabel?.text = "\(student.firstName.notEmptyString()) \(student.lastName.notEmptyString())"

    cell.imageView?.image = UIImage(named: "icon_pin")
    
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let urlString = StudentModel.studentlist[indexPath.row].mediaURL
    if let url = URL(string: urlString.withUrlSchema()) {
      UIApplication.shared.open(url)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

extension String {
  func notEmptyString() -> String{
    if self == "" {
      return "Unknown"
    }else{
      return self
    }
  }

  func withUrlSchema() -> String{
    if self.starts(with: "http"){
      return self
    }else {
      return "\("https://")\(self)"
    }
  }
}
