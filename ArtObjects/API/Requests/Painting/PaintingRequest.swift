//
//  PaintingRequest.swift
//  ArtObjects
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation

enum PaintingRequest {
  case getPainting(id: String)
}

extension PaintingRequest: Request {
  var path: String {
    switch self {
    case .getPainting(let id):
      return "/api/\(APIConstants.language)/collection/\(id)"
    }
  }
  
  var method: RequestMethod {
    .GET
  }
  
  var urlParams: [String : String?] {
    switch self {
    case .getPainting:
      [
        "key": APIConstants.apiKey
      ]
    }
  }
}
