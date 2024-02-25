//
//  SearchViewModel.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Combine
import SwiftUI

final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var debounceSearchText = ""
    @Published var flickrImages: [Flickr] = []
    @Published var isLoading = false
    @Published var isDetailShowing = false
    @Published var errorMessage: String?
    @Published var seleectedPost: Flickr?
    private let service: FlickerManager
    
    init(service: FlickerManager = NetworkManager()) {
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
    
    @Published var columns: [GridItem] = []
    @Published var imageDimensions: CGFloat = 0.0
    
    func updateLayout(verticalSizeClass: UserInterfaceSizeClass) {
        // Adjust columns, spacing, etc. based on orientation
        switch verticalSizeClass {
        case .regular:
            columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
        case .compact:
            columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)
        default:
            break
        }
        
        imageDimensions = (UIScreen.main.bounds.width / CGFloat(columns.count)) - 1
    }
}
