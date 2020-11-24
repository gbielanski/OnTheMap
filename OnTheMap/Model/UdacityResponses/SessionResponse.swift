//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 23/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct SessionResponse : Codable{
  let account: Account
  let session: Session

  enum CodingKeys: String, CodingKey{
    case account
    case session
  }
}

struct Account : Codable{
  let registered : Bool
  let key: String

  enum CodingKeys: String, CodingKey{
    case registered
    case key
  }
}

struct Session : Codable{
  let id : String
  let expiration: String

  enum CodingKeys: String, CodingKey{
    case id
    case expiration
  }
}
