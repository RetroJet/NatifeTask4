//
//  NetworkService.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import Alamofire
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

protocol NetworkServiceProtocol {
    func request(_ url: URL, _ method: HTTPMethod) async throws -> Data
}

extension NetworkServiceProtocol {
    func request(_ url: URL) async throws -> Data {
        try await request(url, .get)
    }
}

nonisolated final class NetworkService: NetworkServiceProtocol {
    func request(_ url: URL, _ method: HTTPMethod = .get) async throws -> Data {
        let afMethod = Alamofire.HTTPMethod(rawValue: method.rawValue)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: afMethod)
                .validate(statusCode: 200...299)
                .responseData { response in
                    switch response.result {
                    case.success(let data):
                        continuation.resume(returning: data)
                    case .failure:
                        let statusCode = response.response?.statusCode ?? 0
                        continuation.resume(throwing: NetworkError.requestFailed(statusCode: statusCode))
                    }
                }
        }
    }
}

private extension NetworkError {
    enum Constants {
        static let invalidURL = "Invalid URL"
        static let requestFailed = "Server error"
    }
}
