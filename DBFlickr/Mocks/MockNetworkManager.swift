//
//  MockNetworkManager.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Foundation

class MockNetworkManager: FlickerManager {
    
    var isSuccess: Bool
    var mockError: FlickrError?
    
    init(isSuccess: Bool = false) {
        self.isSuccess = isSuccess
    }
    
    func fetchImages(_ tag: String) async throws -> [Flickr] {
        if let mockError { throw mockError }
        
        guard let mockData = getMockData() else {
            throw FlickrError.invalidData
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(FlickrItems.self, from: mockData).items
            return decoded
        } catch {
            throw error as? FlickrError ?? .unknownError(error: error)
        }
    }
    
    private func getMockData() -> Data? {
        let mockFile = isSuccess ? "TestData" : "InvalidResponse"
        
        guard let url = Bundle.main.url(forResource: mockFile, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
}
