//
//  DataRepository.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import Foundation

final class DataRepository {

    // MARK: - Properties

    private let networkService: NetworkService
    private let baseURL = Constants.baseURL

    // MARK: - Initializers

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

// MARK: - Internal Methods

extension DataRepository {
    func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "\(baseURL)\(Constants.postsPath)") else {
            throw NetworkError.invalidURL
        }
        let data = try await networkService.request(url)
        return try JSONDecoder().decode(PostsList.self, from: data).posts
    }

    func fetchPost(id: Int) async throws -> PostDetail {
        guard let url = URL(string: "\(baseURL)\(Constants.postDetailPath)\(id).json") else {
            throw NetworkError.invalidURL
        }
        let data = try await networkService.request(url)
        return try JSONDecoder().decode(PostDetailList.self, from: data).post
    }

    func fetchImage(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        return try await networkService.request(url)
    }

}

private extension DataRepository {
    enum Constants {
        static let baseURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api"
        static let postsPath = "/main.json"
        static let postDetailPath = "/posts/"
    }
}
