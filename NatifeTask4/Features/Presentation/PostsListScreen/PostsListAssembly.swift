//
//  PostsListAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import UIKit

final class PostsListAssembly {
    static func build(container: DIContainer = .shared) -> UIViewController {
        let router = PostsListRouter()
        let viewController = PostsListViewController()
        let viewStateFactory = PostsListViewStateFactory()
        let presenter = PostsListPresenter(
            viewStateFactory: viewStateFactory,
            viewController: viewController,
            dataRepository: container.dataRepository,
            router: router
        )

        viewController.presenter = presenter
        router.viewController = viewController

        return viewController
    }
}
