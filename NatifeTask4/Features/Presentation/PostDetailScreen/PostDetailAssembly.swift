//
//  PostDetailAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import UIKit

final class PostDetailAssembly {
    static func build(postId: Int, container: DIContainer = .shared) -> UIViewController {
        let viewController = PostDetailViewController()
        let viewStateFactory = PostDetailViewStateFactory()
        let presenter = PostDetailPresenter(
            viewController: viewController,
            viewStateFactory: viewStateFactory,
            dataRepository: container.dataRepository,
            postId: postId
        )

        viewController.presenter = presenter
        return viewController
    }
}
