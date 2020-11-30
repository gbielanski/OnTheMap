//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 30/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentLocationRequest : Codable{
  let uniqueKey: String
  let firstName: String
  let lastName: String
  let mapString: String
  let mediaURL: String
  let latitude: Double
  let longitude: Double

  enum CodingKeys: String, CodingKey{
    case uniqueKey
    case firstName
    case lastName
    case mapString
    case mediaURL
    case latitude
    case longitude
  }
}
