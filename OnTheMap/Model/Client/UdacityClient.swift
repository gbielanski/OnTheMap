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
    case getStudentDetails(String)
    case getStudentLocations
    case deleteSession
    case postStudentLocation

    var stringValue : String {
      switch self {
      case .createSessionId, .deleteSession: return Endpoints.base + "/session"
      case .getStudentDetails(let key): return Endpoints.base + "/users/\(key)"
      case .getStudentLocations: return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
      case .postStudentLocation: return Endpoints.base + "/StudentLocation"
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

  class func getStudentInfo(completion: @escaping (Bool, Error?) -> Void) {
    taskForGETRequest(url: Endpoints.getStudentDetails(Auth.key).url, responseType: UserProfile.self){ (response, error)
      in
      if let response = response {
        Auth.firstName = response.firstName
        Auth.lastName = response.lastName
        completion(true, nil)
      }else{
        completion(false, error)
      }
    }
  }

  class func postStudentLocations(body: StudentLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
    taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostStudentLocationResponse.self, body: body){ (response, error)
      in
      if let error = error {
        completion(false, error)
      }else{
        completion(true, nil)
      }
    }
  }
  
  class func createSessionId(_ username: String, _ password: String, complation: @escaping (Bool, Error?) -> Void){
    taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: RequestSessionId(udacity: Udacity(username: username, password : password))){
      (response, error)
      in
      
      if let response = response {
        Auth.key = response.account.key
        Auth.session = response.session.id
        complation(true, nil)
      }else{
        complation(false, error)
      }
    }
  }

  class func logout (complation: @escaping (Bool, Error?) -> Void){
    var request = URLRequest(url: Endpoints.deleteSession.url)
    request.httpMethod = "DELETE"
    var xsrfCookie: HTTPCookie? = nil
    let sharedCookieStorage = HTTPCookieStorage.shared
    for cookie in sharedCookieStorage.cookies! {
      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
    }
    if let xsrfCookie = xsrfCookie {
      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
    }

    let session = URLSession.shared
    let task = session.dataTask(with: request) { data, response, error in
      if error != nil {
        complation(false, error)
        return
      }
      Auth.firstName = ""
      Auth.lastName = ""
      Auth.key = ""
      Auth.session = ""

      complation(true, nil)
    }

    task.resume()
  }
  
  class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if (!(responseType is PostStudentLocationResponse.Type)){
      request.addValue("application/json", forHTTPHeaderField: "Accept")
    }

    request.httpBody = try! JSONEncoder().encode(body)

    if ((responseType is PostStudentLocationResponse.Type)){
      print(String(data: request.httpBody!, encoding: .utf8)!)
    }

    let task = URLSession.shared.dataTask(with: request) {
      (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }

      var newData = data
      if (!(responseType is PostStudentLocationResponse.Type)){
        let range = 5..<data.count
        newData = data.subdata(in: range)
      }

      print(String(data: newData, encoding: .utf8)!)
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
        var newData = data
        if (responseType is UserProfile.Type){
          let range = 5..<data.count
          newData = data.subdata(in: range)
        }
        let responseObject = try decoder.decode(ResponseType.self, from: newData)

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
