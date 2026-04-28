//
//  PostDetailViewState.swift
//  NatifeTask4
//
//  Created by Nazar on 17.04.2026.
//

import Foundation

struct PostDetailViewState {
    let item: PostDetailItemViewState?
    let imageData: Data?
    let errorMessage: String?
}

struct PostDetailItemViewState: Hashable {
    let id: Int
    let date: String
    let title: String
    let text: String
    let image: String
    let like: String
}
