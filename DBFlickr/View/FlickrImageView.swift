//
//  FlickrImageView.swift
//  DBFlickr
//
//  Created by Dhruv on 3/7/24.
//

import SwiftUI
import Kingfisher

struct FlickrImageView: View {
    let post: Flickr
    
    var body: some View {
        KFImage(URL(string: post.media.image))
            .resizable()
    }
}

#Preview {
    FlickrImageView(post: Flickr.MockImages[0])
}
