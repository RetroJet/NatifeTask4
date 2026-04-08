//
//  PostDetail.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

struct PostDetailList: Decodable {
    let post: PostDetail
}

nonisolated struct PostDetail: Decodable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postId
        case timeshamp
        case title
        case text
        case postImage
        case likesCount = "likes_count"
    }
}
