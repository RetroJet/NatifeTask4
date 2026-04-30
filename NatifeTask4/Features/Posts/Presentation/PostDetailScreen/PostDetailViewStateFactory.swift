//
//  PostDetailViewStateFactory.swift
//  NatifeTask4
//
//  Created by Nazar on 17.04.2026.
//

import Foundation

struct PostDetailViewStateFactoryInput {
    let post: PostDetailInfo
}

protocol PostDetailViewStateFactoryProtocol {
    func make(_ dto: PostDetailViewStateFactoryInput) -> PostDetailViewState
}

nonisolated final class PostDetailViewStateFactory: PostDetailViewStateFactoryProtocol {
    func make(_ dto: PostDetailViewStateFactoryInput) -> PostDetailViewState {
        let postDate = Date(timeIntervalSince1970: TimeInterval(dto.post.date))

        let item = PostDetailItemViewState(
            id: dto.post.id,
            date: DateFormatter.postDate.string(from: postDate),
            title: dto.post.title,
            text: dto.post.text,
            image: dto.post.postImage,
            like: "\(CommonSymbols.like)\(dto.post.like)"
        )

        return PostDetailViewState(
            item: item,
            imageData: nil,
            errorMessage: nil
        )
    }
}
