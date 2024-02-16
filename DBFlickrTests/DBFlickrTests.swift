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
        let service = MockNetworkManager()
        guard let url = Bundle.main.url(forResource: "TestData", withExtension: "json") else {
            return
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return
        }
        service.mockData = data
        let viewModel = SearchViewModel(service: service)
        
        await viewModel.fetchImages("car")

        XCTAssertTrue(viewModel.flickrImages.count > 0) // ensures that image array has images
        XCTAssertEqual(viewModel.flickrImages.count, 20) // ensures that all images were decoded
    }
    
    func testImageFetchInvalidJson() async {
        let service = MockNetworkManager()
        guard let url = Bundle.main.url(forResource: "InvalidResponse", withExtension: "json") else {
            return
        }
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return
        }
        service.mockData = data
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
}
