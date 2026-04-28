//
//  DataRepository.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import Foundation

protocol DataRepositoryProtocol {
    func fetchPosts() async throws -> [PostsListsInfo]
    func fetchPost(id: Int) async throws -> PostDetailInfo
    func fetchImage(from urlString: String) async throws -> Data
}

nonisolated final class DataRepository {

    // MARK: - Properties

    private let networkService: any NetworkServiceProtocol
    private let baseURL = Constants.baseURL

    // MARK: - Initializers

    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

// MARK: - Internal Methods

extension DataRepository: DataRepositoryProtocol {
    func fetchPosts() async throws -> [PostsListsInfo] {
        guard let url = URL(string: "\(baseURL)\(Constants.postsPath)") else {
            throw NetworkError.invalidURL
        }
        let data = try await networkService.request(url)
        return try JSONDecoder().decode(PostsListResponce.self, from: data).posts.map {
            PostsListMapper.toDomain($0)
        }
    }

    func fetchPost(id: Int) async throws -> PostDetailInfo {
        guard let url = URL(string: "\(baseURL)\(Constants.postDetailPath)\(id).json") else {
            throw NetworkError.invalidURL
        }
        let data = try await networkService.request(url)
        return PostDetailMapper.toDomain(
            try JSONDecoder().decode(PostDetailResponse.self, from: data).post
        )
    }

    func fetchImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        return try await networkService.request(url)
    }

}

private extension DataRepository {
   nonisolated enum Constants {
        static let baseURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api"
        static let postsPath = "/main.json"
        static let postDetailPath = "/posts/"
    }
}
