//
//  PostsListAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import UIKit

final class PostsListAssembly {
    static func build(container: any DIContainerProtocol) -> UIViewController {
        let router = PostsListRouter(container: container)
        let viewController = PostsListViewController()
        let viewStateFactory = PostsListViewStateFactory()
        let presenter = PostsListPresenter(
            viewStateFactory: viewStateFactory,
            viewController: viewController,
            dataRepository: container.getDataRepository(),
            router: router
        )

        viewController.inject(presenter: presenter)
        router.viewController = viewController

        return viewController
    }
}
