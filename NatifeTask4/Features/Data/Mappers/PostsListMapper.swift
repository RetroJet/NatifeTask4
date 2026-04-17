//
//  PostsListMapper.swift
//  NatifeTask4
//
//  Created by Nazar on 16.04.2026.
//

struct PostsListMapper {
    static func toDomain(_ dto: PostsListDTO) -> PostsListsInfo {
        PostsListsInfo(
            id: dto.postId,
            date: dto.timeshamp,
            title: dto.title,
            previewText: dto.previewText,
            like: dto.likesCount
        )
    }
}
