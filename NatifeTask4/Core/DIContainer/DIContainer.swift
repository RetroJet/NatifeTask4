//
//  DIContainer.swift
//  NatifeTask4
//
//  Created by Nazar on 16.04.2026.
//

final class DIContainer {
    static let shared = DIContainer()

    let networkService: NetworkService
    let dataRepository: DataRepository

   private init() {
        self.networkService = NetworkService()
        self.dataRepository = DataRepository(networkService: networkService)
    }
}
