//
//  DBFlickrUITests.swift
//  DBFlickrUITests
//
//  Created by Dhruv on 2/15/24.
//

import XCTest

final class DBFlickrUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchGrid() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("dart")
        searchBar.typeText("\n")
        
        let expectation = XCTestExpectation(description: "Wait for grid response")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        
        let imageGrid = app.otherElements["gridCollectionView"]
        XCTAssertTrue(imageGrid.exists)
        
        imageGrid.swipeUp()
        
        let button = imageGrid.buttons["imageCell18"].firstMatch
        XCTAssertTrue(button.isHittable)
        button.tap()
    }
}
