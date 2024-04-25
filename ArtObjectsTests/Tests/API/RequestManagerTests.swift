//
//  RequestManagerTests.swift
//  ArtObjectsTests
//
//  Created by Simon Kostenko on 25.04.2024.
//

import XCTest
@testable import ArtObjects

class RequestManagerTests: XCTestCase {
  private var requestManager: RequestManagerProtocol?

  override func setUp() {
    super.setUp()
    requestManager = RequestManager(
      apiManager: APIManagerMock()
    )
  }

  func testRequestArtObjects() {
    requestManager?.perform(ArtObjectsRequestMock.getArtObjects, resultHandler: { (result: Result<Response, ArtObjects.RequestError>) in
      guard case .success(let response) = result else {
        XCTFail("Didn't get data from the request manager")
        return
      }
      
      let artObjects = response.artObjects
      
      let first = artObjects.first
      let last = artObjects.last
      XCTAssertEqual(first?.title, "Winter Landscape with Ice Skaters")
      XCTAssertEqual(first?.author, "Hendrick Avercamp")

      XCTAssertEqual(last?.title, "Portraits of Giuliano and Francesco Giamberti da Sangallo")
      XCTAssertEqual(last?.author, "Piero di Cosimo")
    })
  }
}
