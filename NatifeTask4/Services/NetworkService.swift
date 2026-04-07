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

final class NetworkService {
    func request(_ url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
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
