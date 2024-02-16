//
//  SearchViewModel.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var debounceSearchText = ""
    @Published var flickrImages: [Flickr] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let service: FlickerManager
    
    init(service: FlickerManager) {
        self.service = service
        self.debounceTextChanges()
    }
    
    private func debounceTextChanges() {
        debounceSearchText = searchText
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .assign(to: &$debounceSearchText)
    }
    
    @MainActor
    func fetchImages(_ tag: String) async {
        if tag.count < 1 { return }
        isLoading = true
        do {
            self.flickrImages = try await service.fetchImages(tag)
            isLoading = false
        } catch {
            guard let error = error as? FlickrError else { return }
            self.errorMessage = error.customDescription
        }
    }
}
