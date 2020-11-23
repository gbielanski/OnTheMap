//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by Grzegorz Bielanski on 23/11/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UdacityErrorResponse : Codable{
    let status: Int
    let error: String

    enum CodingKeys: String, CodingKey{
        case status
        case error
    }
}

extension UdacityErrorResponse : LocalizedError{
    var errorDescription: String? {
        return error
    }
}
