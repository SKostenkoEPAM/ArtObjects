//
//  RequestError.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

enum RequestError: Error {
  case invalidURL
  case noResponse
  case decode
  case unauthorized
  case unexpectedStatusCode
  case unknown
  
  var reason: String {
    switch self {
    case .invalidURL, .noResponse:
      return "An error occurred while fetching data "
    case .decode:
      return "An error occurred while decoding data"
    case .unauthorized:
      return "User is not authorized"
    case .unexpectedStatusCode, .unknown:
      return "Something went wrong"
    }
  }
}
