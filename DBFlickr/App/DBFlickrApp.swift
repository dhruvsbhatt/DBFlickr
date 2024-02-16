//
//  DBFlickrApp.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import SwiftUI

@main
struct DBFlickrApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(service: NetworkManager())
        }
    }
}
