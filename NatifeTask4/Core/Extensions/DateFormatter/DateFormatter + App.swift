//
//  DateFormatter + App.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import Foundation

extension DateFormatter {
    static let postDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
}
