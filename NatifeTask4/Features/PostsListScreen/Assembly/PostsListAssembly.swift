//
//  PostsListAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import UIKit

final class PostsListAssembly {
    static func build() -> UIViewController {
        let networkService = NetworkService()
        let postsRepository = PostsRepository(networkService: networkService)
        let router = PostsListRouter()
        let viewController = PostsListViewController()
        let presenter = PostsListPresenter(
            viewController: viewController,
            postRepository: postsRepository,
            router: router
        )

        viewController.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}
