//
//  PostDetailAssembly.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import UIKit

final class PostDetailAssembly {
    static func build(postId: Int, networkService: NetworkService) -> UIViewController {
        let dataRepository = DataRepository(networkService: networkService)
        let viewController = PostDetailViewController()
        let presenter = PostDetailPresenter(
            viewController: viewController,
            dataRepository: dataRepository,
            postId: postId
        )

        viewController.presenter = presenter
        return viewController
    }
}
