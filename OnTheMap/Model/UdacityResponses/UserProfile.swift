//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 28/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
  let firstName: String
  let lastName: String
  let nickname: String

  enum CodingKeys: String, CodingKey {
    case firstName = "first_name"
    case lastName = "last_name"
    case nickname
  }

}
