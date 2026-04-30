//
//  PostDetailAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import UIKit

final class PostDetailAssembly {
    static func build(postId: Int, container: any DIContainerProtocol) -> UIViewController {
        let viewController = PostDetailViewController()
        let viewStateFactory = PostDetailViewStateFactory()
        let presenter = PostDetailPresenter(
            viewController: viewController,
            viewStateFactory: viewStateFactory,
            dataRepository: container.getDataRepository(),
            postId: postId
        )

        viewController.inject(presenter: presenter)
        return viewController
    }
}
