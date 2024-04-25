//
//  ArtObjectsRequest.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation

enum ArtObjectsRequest {
  case getArtObjects(page: Int)
}

extension ArtObjectsRequest: Request {
  
  var path: String {
    "/api/\(APIConstants.language)/collection"
  }
  
  var method: RequestMethod {
    .GET
  }
  
  var urlParams: [String : String?] {
    switch self {
    case .getArtObjects(let page):
      [
        "p": String(page),
        "key": APIConstants.apiKey
      ]
    }
  }
}
