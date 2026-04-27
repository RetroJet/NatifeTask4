//
//  LayoutType.swift
//  NatifeTask4
//
//  Created by Nazar on 16.04.2026.
//

enum LayoutType {
    case list
    case grid
    case gallery
}

extension LayoutType {
    var tabIndex: Int {
        switch self {
        case .list: return 0
        case .grid: return 1
        case .gallery: return 2
        }
    }
}
