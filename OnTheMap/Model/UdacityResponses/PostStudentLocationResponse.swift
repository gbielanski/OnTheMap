//
//  PostStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 30/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct PostStudentLocationResponse : Codable{
  let objectId: String
  let createdAt: String

  enum CodingKeys: String, CodingKey{
    case objectId
    case createdAt
  }
}
