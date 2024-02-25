//
//  DBFlickrApp.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import SwiftUI

@main
struct DBFlickrApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            SearchView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        print("Is UI Test running: ", UITestingHelper.isUITesting)
        #endif
        return true
    }
}
