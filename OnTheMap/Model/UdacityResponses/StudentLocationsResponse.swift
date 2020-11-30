//
//  StudentLocationsResponse.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 24/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class StudentLocationsResponse : Codable {

  let results: [StudentInformation]

  enum CodingKeys: String, CodingKey{
    case results
  }
}


class StudentInformation : Codable{
  let firstName: String
  let lastName: String
  let longitude: Float
  let latitude: Float
  let mapString: String
  let mediaURL: String
  let uniqueKey: String
  let objectId: String
  let createdAt: String
  let updatedAt: String

  enum CodingKeys: String, CodingKey{
      case firstName
      case lastName
      case longitude
      case latitude
      case mapString
      case mediaURL
      case uniqueKey
      case objectId
      case createdAt
      case updatedAt
  }

}
