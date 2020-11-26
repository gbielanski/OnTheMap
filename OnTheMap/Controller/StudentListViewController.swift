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

  override func viewDidLoad() {
    super.viewDidLoad()
    _ = UdacityClient.getStudentLocations { students, error in
      StudentModel.studentlist = students
      print(students)
      for s in students {
        print(s.firstName)
      }

      self.tableView.reloadData()
    }

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    tableView.reloadData()
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
}
