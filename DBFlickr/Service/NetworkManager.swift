//
//  NetworkManager.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Foundation

protocol FlickerManager {
    func fetchImages(_ tag: String) async throws -> [Flickr]
}

final class NetworkManager: FlickerManager {
    
    static let shared = NetworkManager()
    let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
        
    func fetchImages(_ tag: String) async throws -> [Flickr] {
        let searchURL = baseURL + tag
        guard let url = URL(string: searchURL) else {
            throw FlickrError.requestFailed(description: "Invalid endpoint")
        }
        
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(FlickrItems.self, from: data).items
            return decoded
        } catch {
            throw FlickrError.jsonParsingFailure
        }
    }
}
