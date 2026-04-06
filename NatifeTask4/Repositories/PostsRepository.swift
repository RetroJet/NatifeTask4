//
//  PostsRepository.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import Foundation

final class PostsRepository {

    // MARK: - Properties

    private let networkService: NetworkService
    private let baseURL = Constants.baseURL

    // MARK: - Initializers

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: - Internal Methods

extension PostsRepository {
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)\(Constants.postsPath)") else {
            throw NetworkError.invalidURL
        }
        let data = try await networkService.request(url)
        return try JSONDecoder().decode(PostsList.self, from: data).posts
    }
}

private extension PostsRepository {
    enum Constants {
        static let baseURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api"
        static let postsPath = "/main.json"
    }
}
