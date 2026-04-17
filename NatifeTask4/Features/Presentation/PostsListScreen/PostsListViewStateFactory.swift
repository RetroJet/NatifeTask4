//
//  PostsListViewStateFactory.swift
//  NatifeTask4
//
//  Created by Nazar on 13.04.2026.
//

import Foundation

struct PostsListViewStateFactoryInput {
    let posts: [PostsListsInfo]
    let expandedItems: Set<Int>
    let layoutType: LayoutType
}

protocol PostsListViewStateFactoryProtocol {
    func make(_ state: PostsListViewStateFactoryInput) -> PostsListViewState
}

final class PostsListViewStateFactory: PostsListViewStateFactoryProtocol {
    func make(_ state: PostsListViewStateFactoryInput) -> PostsListViewState {

        let items = state.posts.map { post in
            let isExpanded = state.expandedItems.contains(post.id)
            let isShortText = post.previewText.count < 100
            let postDate = Date(timeIntervalSince1970: TimeInterval(post.date))

           return PostsListItemViewState(
                id: post.id,
                date: DateFormatter.postDate.string(from: postDate),
                title: post.title,
                previewText: post.previewText,
                like: "\(CommonSymbols.like)\(post.like)",
                isExpanded: isExpanded,
                showExpandButton: state.layoutType == .gallery ? false : !isShortText,
                titleNumberOfLines: state.layoutType == .grid ? 1 : 0
            )
        }

        return PostsListViewState(items: items, selectedTab: state.layoutType)
    }
}
