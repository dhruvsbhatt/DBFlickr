//
//  SearchView.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    @Namespace var namespace
    
    init() {
#if DEBUG
        if UITestingHelper.isUITesting {
            self._viewModel = StateObject(wrappedValue: SearchViewModel(service: MockNetworkManager(isSuccess: UITestingHelper.isNetworkingSuccessful)))
        } else {
            self._viewModel = StateObject(wrappedValue: SearchViewModel())
        }
#else
        self._viewModel = StateObject(wrappedValue: SearchViewModel())
#endif
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: viewModel.columns, spacing: 1) {
                        ForEach(viewModel.flickrImages) { post in
                            FlickrImageView(post: post)
                                .scaledToFill()
                                .matchedGeometryEffect(id: post.id, in: namespace)
                                .frame(width: viewModel.imageDimensions, height: viewModel.imageDimensions)
                                .clipped()
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.selectImage(post)
                                        viewModel.isDetailShowing.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            viewModel.loadDetails.toggle()
                                        }
                                    }
                                }
                                .accessibilityIdentifier("searchImage_\(post.id)")
                        }
                    }
                    .accessibilityIdentifier("gridCollectionView")
                    .searchable(text: $viewModel.searchText, prompt: "Search ...")
                    .onChange(of: viewModel.debounceSearchText) { _, newValue in
                        Task { await viewModel.fetchImages(newValue) }
                    }
                }
                .opacity(viewModel.selectedPost == nil ? 1 : 0)
                .navigationTitle("Flikr")
            }
            .overlay {
                if viewModel.flickrImages.isEmpty, !viewModel.isLoading {
                    ContentUnavailableView("No Results", systemImage: "exclamationmark.triangle", description: Text("Try a new search!"))
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
            
            if viewModel.isDetailShowing {
                DetailView(post: viewModel.selectedPost!, namespace: namespace, viewModel: viewModel)
                    .zIndex(1)
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
    SearchView()
}
