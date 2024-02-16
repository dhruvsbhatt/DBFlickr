//
//  AttributedText.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Foundation
import SwiftUI

struct AttributedText: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.attributedText = parseHTML(htmlString)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update content if needed
    }

    private func parseHTML(_ htmlString: String) -> NSAttributedString {
        var attrString = NSAttributedString(string: "")
        guard let htmlData = htmlString.data(using: .utf8) else { return attrString }
        do {
            attrString = try NSAttributedString(data: htmlData,
                                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                                     documentAttributes: nil)
        } catch {
            print("Parsing error: ", error)
        }
        return attrString
    }
}

struct ContentView: View {
    let htmlString = "<b>This is some bold text.</b>"

    var body: some View {
        AttributedText(htmlString: htmlString)
            .frame(width: 300, height: 200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
