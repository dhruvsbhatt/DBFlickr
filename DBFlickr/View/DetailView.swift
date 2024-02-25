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
    
    var body: some View {
        ScrollView {
            VStack() {
                KFImage(URL(string: post.media.image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    .clipShape(Rectangle())
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(post.title)
                        .font(.title)
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
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $isSheetOpen, content: {
                ActivityView(showing: $isSheetOpen, activityItems: post)
            })
        }
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