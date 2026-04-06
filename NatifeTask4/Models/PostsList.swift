//
//  PostsList.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

struct PostsList: Decodable {
    let posts: [Post]
}

nonisolated struct Post: Hashable, Decodable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timeshamp
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
