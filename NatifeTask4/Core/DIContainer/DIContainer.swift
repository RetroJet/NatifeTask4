//
//  DIContainer.swift
//  NatifeTask4
//
//  Created by Nazar on 16.04.2026.
//

protocol DIContainerProtocol {
    func getDataRepository() -> any DataRepositoryProtocol
}

final class DIContainer {
    private let networkService: any NetworkServiceProtocol
    private let dataRepository: any DataRepositoryProtocol

    init() {
        self.networkService = NetworkService()
        self.dataRepository = DataRepository(networkService: networkService)
    }
}

extension DIContainer: DIContainerProtocol {
    func getDataRepository() -> any DataRepositoryProtocol {
        dataRepository
    }
}
