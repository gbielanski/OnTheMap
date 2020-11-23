//
//  RequestSessionId.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 23/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct RequestSessionId : Codable{
  let udacity : Udacity

  enum CodingKeys: String, CodingKey{
    case udacity
  }
}

  struct Udacity : Codable{
    let username: String
    let password: String

    enum CodingKeys: String, CodingKey{
      case username
      case password
    }
}
