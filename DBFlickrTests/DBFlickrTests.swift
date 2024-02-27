//
//  DBFlickrTests.swift
//  DBFlickrTests
//
//  Created by Dhruv on 2/15/24.
//

import XCTest
@testable import DBFlickr

class DBFlickrTests: XCTestCase {

    func testSuccessfulImageResponse() async {
        let service = MockNetworkManager(isSuccess: true)
        let viewModel = SearchViewModel(service: service)
        
        await viewModel.fetchImages("car")

        XCTAssertTrue(viewModel.flickrImages.count > 0) // ensures that image array has images
        XCTAssertEqual(viewModel.flickrImages.count, 20) // ensures that all images were decoded
    }
    
    func testImageFetchInvalidJson() async {
        let service = MockNetworkManager(isSuccess: false)
        let viewModel = SearchViewModel(service: service)
        
        await viewModel.fetchImages("car")

        XCTAssertEqual(viewModel.flickrImages.count, 0)
    }
    
    func testThrowsInvalidStatusCode() async {
        let service = MockNetworkManager()
        service.mockError = FlickrError.invalidStatusCode(statusCode: 404)
        
        let viewModel = SearchViewModel(service: service)
        
        await viewModel.fetchImages("tag")
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, FlickrError.invalidStatusCode(statusCode: 404).customDescription)
    }
    
    func testStringExtensionWrongDateInput() {
        let strInput = "12/01/2024"
        XCTAssertEqual(strInput.timestampString(), "")
    }
    
    func testStringExtensionCorrectDateInput() {
        let strInput = "2024-02-14T23:36:51Z"
        XCTAssertEqual(strInput.timestampString(), "February 14, 2024")
    }
}
