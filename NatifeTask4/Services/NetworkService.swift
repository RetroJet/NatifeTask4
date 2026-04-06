//
//  NetworkService.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
}

final class NetworkService {
    func request(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
