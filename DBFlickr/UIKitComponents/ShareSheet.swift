//
//  ShareSheet.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import UIKit
import SwiftUI
import Foundation
import Kingfisher
import LinkPresentation

struct ActivityView: UIViewControllerRepresentable {
    @Binding var showing: Bool
    var activityItems: Flickr
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        
        let text = activityItems.title
        let imageURL = URL(string: activityItems.media.image)
        
        let itemSource = ShareActivityItemSource(shareText: text, shareImage: imageURL!, shareUrl: URL(string: activityItems.link)!)
        let shareAll = [imageURL as Any, text, itemSource] as [Any]
        
        let controller = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Optional updates to the activity view controller
    }
}

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    
    var shareText: String
    var shareImage: URL
    var shareUrl : URL
    var linkMetaData = LPLinkMetadata()
    
    init(shareText: String, shareImage: URL, shareUrl: URL) {
        self.shareText = shareText
        self.shareImage = shareImage
        self.shareUrl = shareUrl
        linkMetaData.title = shareText
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage(named: "AppIcon ") as Any
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return nil
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.originalURL = self.shareUrl
        metadata.url = metadata.originalURL
        metadata.title = self.shareText
        let uiImageView = UIImageView()
        uiImageView.kf.setImage(with: self.shareImage)
        metadata.iconProvider = NSItemProvider(object: uiImageView.image!)
        return metadata
    }
}
