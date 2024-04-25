//
//  Request.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 24.04.2024.
//

import Foundation

protocol Request {
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
  var method: RequestMethod { get }
  var headers: [String: String] { get }
  var body: [String: Any] { get }
  var urlParams: [String: String?] { get }
}

extension Request {
  var scheme: String {
    "https"
  }
  
  var host: String {
    APIConstants.host
  }
  
  var headers: [String: String] {
    [:]
  }
  
  var body: [String: Any] {
    [:]
  }
  
  var urlParams: [String: String?] {
    [:]
  }
  
  func createURLRequest() throws -> URLRequest {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = path
    
    if !urlParams.isEmpty {
      components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
    }
    
    guard let url = components.url else { throw RequestError.invalidURL }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    
    if !headers.isEmpty {
      urlRequest.allHTTPHeaderFields = headers
    }
    
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if !body.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
    }
    
    return urlRequest
  }
}
