//
//  PostsListAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import UIKit

final class PostsListAssembly {
    static func build(networkService: NetworkService) -> UIViewController {
        let dataRepository = DataRepository(networkService: networkService)
        let router = PostsListRouter(networkService: networkService)
        let viewController = PostsListViewController()
        let presenter = PostsListPresenter(
            viewController: viewController,
            dataRepository: dataRepository,
            router: router
        )

        viewController.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}
