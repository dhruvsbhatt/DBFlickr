//
//  Flickr.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Foundation

struct FlickrItems: Decodable {
    let items: [Flickr]
}

struct Flickr: Hashable, Decodable {
    
    let media: Media
    let title: String
    let description: String
    let author: String
    let published: String
    let link: String
    
    private enum CodingKeys: String, CodingKey {
        case media, title, description, author, published, link
    }
}

struct Media: Decodable, Hashable {
    let image: String
    
    private enum CodingKeys: String, CodingKey {
        case image = "m"
    }
}

extension Flickr: Identifiable {
    var id: String { author + link }
}

extension Flickr {
    static var MockImages: [Flickr] = [.init(media: Media(image: "https://live.staticflickr.com/65535/53528258724_1d189ae035_m.jpg"),
                                             title: "North American Porcupine",
                                             description: "<p><a href=\"https://www.flickr.com/people/barbaraannphotos/\">barbara.ann316</a> posted a photo:</p> <p><a href=\"https://www.flickr.com/photos/barbaraannphotos/53528258724/\" title=\"North American Porcupine\"><img src=\"https://live.staticflickr.com/65535/53528258724_1d189ae035_m.jpg\" width=\"240\" height=\"160\" alt=\"North American Porcupine\" /></a></p>",
                                             author: "nobody@flickr.com (\"barbara.ann316\")",
                                             published: "2024-02-14T02:36:48Z",
                                             link: "")]
}
