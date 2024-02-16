//
//  StringExtension.swift
//  DBFlickr
//
//  Created by Dhruv on 2/15/24.
//

import Foundation

extension String {
    func timestampString() -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else {
            return ""
        }
        
        let desiredFormatter = DateFormatter()
        desiredFormatter.dateFormat = "MMMM d, yyyy"

        return desiredFormatter.string(from: date)
    }
}
