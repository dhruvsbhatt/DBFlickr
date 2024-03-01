//
//  DetailView.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import SwiftUI
import SwiftSoup
import Kingfisher

struct DetailView: View {
    let post: Flickr
    @State var isSheetOpen = false
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
       
    
    var body: some View {
        ScrollView {
            VStack() {
                KFImage(URL(string: post.media.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accessibilityAddTraits(.isImage)
                    .scaleEffect(currentZoom + totalZoom)
                    .clipped()
                    .gesture(
                        MagnifyGesture()
                            .onChanged { value in
                                currentZoom = value.magnification - 1
                            }
                            .onEnded { value in
                                totalZoom += currentZoom
                                currentZoom = 0
                                if value.magnification < 1.0 {
                                    withAnimation {
                                        totalZoom = 1.0
                                    }
                                }
                            }
                    )
                    .accessibilityZoomAction { action in
                        if action.direction == .zoomIn {
                            totalZoom += 1
                        } else {
                            totalZoom -= 1
                        }
                    }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(self.showDimensions)
                    Text(post.title)
                        .font(.title)
                        .accessibilityIdentifier("DetailTitle")
                    Text("Posted by: " + formattedUsername)
                        .font(.title2)
                        .fontWeight(.medium)
                    Text(post.published.timestampString())
                        .font(.title2)
                    Text(self.getDescription()) // It will only show the description if it exists in the html payload
                        .font(.title3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
            }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        isSheetOpen.toggle()
                        AccessibilityNotification.Announcement("Loading share screen")
                            .post()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityIdentifier("ShareSheetButtonIdentifier")
                    .accessibilityAddTraits(.isToggle)
                }
            }
            .sheet(isPresented: $isSheetOpen, content: {
                ActivityView(showing: $isSheetOpen, activityItems: post)
            })
        }
    }
    
    private var imageSize: CGSize {
        do {
            let doc = try SwiftSoup.parse(post.description)
            if let strWidth = try doc.select("img[width]").array().compactMap({ try? $0.attr("width").description }).first,
               let dblWidth = Double(strWidth),
               let strHeight = try doc.select("img[height]").array().compactMap({ try? $0.attr("height").description }).first,
               let dblHeight = Double(strHeight) {
                return CGSize(width: dblWidth, height: dblHeight)
            }
        } catch {
            print("Error parsing the html for width and height")
        }
        return CGSizeZero
    }
    
    private var showDimensions: String {
        return "Width: \(imageSize.width) and Height: \(imageSize.height)"
    }
    
    private var formattedUsername: String {
        let updatedUsername = post.author.replacingOccurrences(of: "\")", with: "")
        return updatedUsername.replacingOccurrences(of: "nobody@flickr.com (\"", with: "")
    }
    
    private func getDescription() -> String {
        do {
            let doc = try SwiftSoup.parse(post.description)
            let paragraphs = try doc.select("p").map { try $0.text() }
            if paragraphs.count > 2 {
                return paragraphs.last!
            }
        } catch {
            return ""
        }
        return ""
    }
}

#Preview {
    DetailView(post: Flickr.MockImages[0])
}
