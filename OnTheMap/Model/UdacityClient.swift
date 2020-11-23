//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 23/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class UdacityClient{

  enum Endpoints {
    static let base = "https://onthemap-api.udacity.com/v1"

    case createSessionId

    var stringValue : String {
      switch self {
      case .createSessionId: return Endpoints.base + "/session"
      }
    }

    var url: URL {
      return URL(string: stringValue)!
    }

  }
}
