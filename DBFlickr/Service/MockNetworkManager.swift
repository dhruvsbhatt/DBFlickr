//
//  MockNetworkManager.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Foundation

class MockNetworkManager: FlickerManager {
    
    var mockData: Data!
    var mockError: FlickrError?
    
    func fetchImages(_ tag: String) async throws -> [Flickr] {
        if let mockError { throw mockError }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(FlickrItems.self, from: mockData).items
            return decoded
        } catch {
            throw error as? FlickrError ?? .unknownError(error: error)
        }
    }
}
