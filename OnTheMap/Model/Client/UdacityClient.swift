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
    case getStudentLocations
    
    var stringValue : String {
      switch self {
      case .createSessionId: return Endpoints.base + "/session"
      case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
      }
    }
    
    var url: URL {
      return URL(string: stringValue)!
    }
    
  }

  class func getStudentLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
      taskForGETRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationsResponse.self){ (response, error)
          in
          if let response = response {
              completion(response.results, nil)
          }else{
              completion([], error)
          }
      }
  }
  
  class func createSessionId(_ username: String, _ password: String, complation: @escaping (Bool, Error?) -> Void){
    taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: RequestSessionId(udacity: Udacity(username: username, password : password))){
      (response, error)
      in
      
      if let response = response {
        complation(true, nil)
      }else{
        complation(false, error)
      }
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

  @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask{
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      let decoder = JSONDecoder()
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: data)
        DispatchQueue.main.async {
          completion(responseObject, nil)
        }
      } catch {
        do {
          let errorResponse = try decoder.decode(UdacityErrorResponse.self, from: data)
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
    return task

  }
}
