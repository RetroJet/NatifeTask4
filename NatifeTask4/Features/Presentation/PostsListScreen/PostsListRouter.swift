//
//  PostsListRouter.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import UIKit

protocol PostsListRouterProtocol: AnyObject {
    func openPostDetail(_ postId: Int)
}

final class PostsListRouter {
    weak var viewController: UIViewController?
}

// MARK: - PostsListRouterProtocol

extension PostsListRouter: PostsListRouterProtocol {
    func openPostDetail(_ postId: Int) {
        let postDetailViewController = PostDetailAssembly.build(postId: postId)
        viewController?.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
}
