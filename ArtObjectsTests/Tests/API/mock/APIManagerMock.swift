//
//  APIManagerMock.swift
//  ArtObjectsTests
//
//  Created by Simon Kostenko on 25.04.2024.
//

import XCTest
@testable import ArtObjects

struct APIManagerMock: APIManagerProtocol {
  func perform(_ request: Request, resultHandler: @escaping (Result<Data, RequestError>) -> Void) {
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: request.path), options: .mappedIfSafe)
      resultHandler(.success(data))
    } catch {
      resultHandler(.failure(RequestError.unknown))
    }
  }
}
