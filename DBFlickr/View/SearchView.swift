//
//  SearchView.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    private let service: FlickerManager
    @StateObject var viewModel: SearchViewModel
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    
    init(service: FlickerManager) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: SearchViewModel(service: service))
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: viewModel.columns, spacing: 1) {
                        ForEach(viewModel.flickrImages) { post in
                            NavigationLink(value: post) {
                                KFImage(URL(string: post.media.image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: viewModel.imageDimensions, height: viewModel.imageDimensions)
                                    .clipped()
                            }
                        }
                    }
                    .searchable(text: $viewModel.searchText, prompt: "Search ...")
                    .onChange(of: viewModel.debounceSearchText) { _, newValue in
                        Task { await viewModel.fetchImages(newValue) }
                    }
                }
                .navigationTitle("Flikr")
                .navigationDestination(for: Flickr.self) { post in
                    withAnimation(.easeInOut) {
                        DetailView(post: post)
                    }
                }
            }
            .overlay {
                if viewModel.flickrImages.isEmpty, !viewModel.isLoading {
                    ContentUnavailableView("No Results", systemImage: "exclamationmark.triangle", description: Text("Try a new search!"))
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .onChange(of: verticalSizeClass) { _, _ in
            viewModel.updateLayout(verticalSizeClass: verticalSizeClass!)
        }
        .onAppear {
            viewModel.updateLayout(verticalSizeClass: verticalSizeClass!)
        }
    }
}

#Preview {
    SearchView(service: MockNetworkManager())
}
