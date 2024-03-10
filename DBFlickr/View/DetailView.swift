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
    let namespace: Namespace.ID
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    FlickrImageView(post: post)
                        .matchedGeometryEffect(id: post.id, in: namespace)
                        .frame(height: 300)
                        .accessibilityAddTraits(.isImage)
                    
                    if viewModel.loadDetails {
                        HStack {
                            Button {
                                viewModel.loadDetails.toggle()
                                withAnimation {
                                    viewModel.isDetailShowing.toggle()
                                    viewModel.unselectImage()
                                }
                                AccessibilityNotification.Announcement("Return back to main screen")
                                    .post()
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .accessibilityIdentifier("BackButtonButtonIdentifier")
                            .accessibilityAddTraits(.isToggle)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring) {
                                    isSheetOpen.toggle()
                                    AccessibilityNotification.Announcement("Loading share screen")
                                        .post()
                                }
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(.red)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .accessibilityIdentifier("ShareSheetButtonIdentifier")
                            .accessibilityAddTraits(.isToggle)
                        }
                        .padding(.top, 35)
                        .padding(.horizontal)
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
                
                Spacer()
            }
            .sheet(isPresented: $isSheetOpen, content: {
                ActivityView(showing: $isSheetOpen, activityItems: post)
            })
        }
        .background(viewModel.loadDetails ? .white : Color(UIColor.clear))
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
    DetailView(post: Flickr.MockImages[0], namespace: Namespace().wrappedValue, viewModel: SearchViewModel())
}
