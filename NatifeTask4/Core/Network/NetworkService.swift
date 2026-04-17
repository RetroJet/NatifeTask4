//
//  NetworkService.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Constants.invalidURL
        case .requestFailed(let statusCode):
            return "\(Constants.requestFailed): \(statusCode)"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class NetworkService {
    func request(_ url: URL, _ method: HTTPMethod = .get) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw NetworkError.requestFailed(statusCode: statusCode)
        }

        return data
    }
}

private extension NetworkError {
    enum Constants {
        static let invalidURL = "Invalid URL"
        static let requestFailed = "Server error"
    }
}
