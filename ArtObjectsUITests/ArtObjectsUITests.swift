//
//  ArtObjectsUITests.swift
//  ArtObjectsUITests
//
//  Created by Simon Kostenko on 24.04.2024.
//

import XCTest

final class ArtObjectsUITests: XCTestCase {
  
  var app: XCUIApplication!

    override func setUpWithError() throws {
      try super.setUpWithError()
      continueAfterFailure = false
      app = XCUIApplication()
      app.launch()
    }
  
  func testOpenCloseFirstArtObject() {
    let cell = app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element
    let exists = NSPredicate(format: "exists == 1")
    let expectation = expectation(for: exists, evaluatedWith: cell)
    if XCTWaiter().wait(for: [expectation], timeout: 20) == .timedOut {
      XCTFail("ArtObjects screen is not displayed")
    }
    
    cell.tap()
    XCTAssertTrue(app.otherElements["PaintingView"].exists, "Painting view is not displayed")
    app.navigationBars["Details"].buttons["ArtObjects"].tap()
  }
}
