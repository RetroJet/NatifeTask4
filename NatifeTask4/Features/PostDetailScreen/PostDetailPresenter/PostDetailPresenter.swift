//
//  PostDetailPresenter.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import Foundation

protocol PostDetailPresenterProtocol: AnyObject {
    func fetchPost()
    func loadImage(from url: String)
}

final class PostDetailPresenter {

    // MARK: - Properties

    private weak var viewController: PostDetailViewControllerProtocol?
    private let dataRepository: DataRepository
    private let postId: Int

    // MARK: - Initializers

    init(viewController: PostDetailViewControllerProtocol, dataRepository: DataRepository, postId: Int) {
        self.viewController = viewController
        self.dataRepository = dataRepository
        self.postId = postId
    }
}

// MARK: - Private Methods

private extension PostDetailPresenter {
    enum Constants {
        static let fetchPost = "FetchPost error"
        static let imageLoad = "Image load error"
    }
}

// MARK: - PostDetailPresenterProtocol

extension PostDetailPresenter: PostDetailPresenterProtocol {
    func fetchPost() {
        Task {
            do {
                let post = try await dataRepository.fetchPost(id: postId)
                viewController?.showPost(post)
            } catch {
                print("\(Constants.fetchPost): \(error)")
                viewController?.showError(PostDetailText.failedToLoadPost)
            }
        }
    }

    func loadImage(from url: String) {
        Task {
            do {
                let data = try await dataRepository.fetchImage(from: url)
                viewController?.showImage(data)
            } catch {
                print("\(Constants.imageLoad): \(error)")
            }
        }
    }

}
