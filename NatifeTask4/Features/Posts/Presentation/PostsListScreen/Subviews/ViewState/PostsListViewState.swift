//
//  PostsListViewState.swift
//  NatifeTask4
//
//  Created by Nazar on 13.04.2026.
//

struct PostsListViewState {
    let items: [PostsListItemViewState]
    let selectedTab: LayoutType
    let errorMessage: String?
}

struct PostsListItemViewState: Hashable {
    let id: Int
    let date: String
    let title: String
    let previewText: String
    let like: String
    let isExpanded: Bool
    let showExpandButton: Bool
    let titleNumberOfLines: Int
}
