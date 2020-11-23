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

  class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = try! JSONEncoder().encode(body)
    let task = URLSession.shared.dataTask(with: request) {
      (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }

      let range = 5..<data.count
      let newData = data.subdata(in: range)

      let decoder = JSONDecoder()

      do {

        let response = try decoder.decode(ResponseType.self, from: newData)
        DispatchQueue.main.async {
          completion(response , nil)
        }
      } catch {
        do {
          let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: newData)
          DispatchQueue.main.async {
            completion(nil, errorResponse)
          }
        }catch{
          DispatchQueue.main.async {
            completion(nil, error)
          }
        }
      }
    }

    task.resume()
  }
}
