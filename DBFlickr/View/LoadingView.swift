//
//  LoadingView.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(UIColor.clear)
                .ignoresSafeArea(.all)
            ProgressView("Loading...")
                .foregroundStyle(.secondary)
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
        }
    }
}

#Preview {
    LoadingView()
}
