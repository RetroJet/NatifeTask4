//
//  PostDetailMapper.swift
//  NatifeTask4
//
//  Created by Nazar on 16.04.2026.
//

struct PostDetailMapper {
    static func toDomain(_ dto: PostDetailDTO) -> PostDetailInfo {
        PostDetailInfo(
            id: dto.postId,
            date: dto.timeshamp,
            title: dto.title,
            text: dto.text,
            postImage: dto.postImage,
            like: dto.likesCount
        )
    }
}
