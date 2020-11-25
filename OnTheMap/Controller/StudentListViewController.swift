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

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = UdacityClient.getStudentLocations { students, error in
      print(students)
      for s in students {
        print(s.firstName)
      }
    }

  }
  
}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
    return cell
  }


  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}
