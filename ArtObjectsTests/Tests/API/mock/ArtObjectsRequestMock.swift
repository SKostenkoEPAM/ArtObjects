//
//  ArtObjectsRequestMock.swift
//  ArtObjectsTests
//
//  Created by Simon Kostenko on 25.04.2024.
//

import Foundation
@testable import ArtObjects

enum ArtObjectsRequestMock: Request {
  case getArtObjects

  var method: RequestMethod {
    return .GET
  }

  var path: String {
    guard let path = Bundle.main.path(forResource: "ArtObjectsMock", ofType: "json") else { return "" }
    return path
  }
}
