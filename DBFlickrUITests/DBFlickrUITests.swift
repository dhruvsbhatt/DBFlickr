//
//  DBFlickrUITests.swift
//  DBFlickrUITests
//
//  Created by Dhruv on 2/15/24.
//

import XCTest

final class DBFlickrUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-networking-success": "1"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func test_grid_correct_number_of_items() {
        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("porcupine")
        searchBar.typeText("\n")
        
        let imageGrid = app.otherElements["gridCollectionView"]
        XCTAssertTrue(imageGrid.waitForExistence(timeout: 5), "Grid is visible")
        
        let predicate = NSPredicate(format: "identifier CONTAINS 'searchImage_'")
        let gridItems = imageGrid.buttons.containing(predicate)
        XCTAssertEqual(gridItems.count, 20, "There should be 20 items")
        
        let button = gridItems.firstMatch
        XCTAssertTrue(button.isHittable)
        button.tap()
        
        // Verifying detail screen
        
        XCTAssertEqual(app.navigationBars.element.identifier, "Detail")
        XCTAssertTrue(app.staticTexts["Rico - Porcupine"].exists)
        
        let shareButton = app.buttons["ShareSheetButtonIdentifier"]
        XCTAssertTrue(shareButton.isHittable)
        shareButton.tap()
    }
}
