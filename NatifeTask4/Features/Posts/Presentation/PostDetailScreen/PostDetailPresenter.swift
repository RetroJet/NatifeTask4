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
    private let viewStateFactory: PostDetailViewStateFactoryProtocol
    private let dataRepository: any DataRepositoryProtocol
    private let postId: Int

    // MARK: - Initializers

    init(
        viewController: PostDetailViewControllerProtocol,
        viewStateFactory: PostDetailViewStateFactoryProtocol,
        dataRepository: any DataRepositoryProtocol,
        postId: Int
    ) {
        self.viewController = viewController
        self.viewStateFactory = viewStateFactory
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
                let state = viewStateFactory.make(PostDetailViewStateFactoryInput(post: post))

                await MainActor.run {
                    self.viewController?.render(state)
                    self.loadImage(from: post.postImage)
                }
            } catch {
                print("\(Constants.fetchPost): \(error)")
                await MainActor.run {
                    self.viewController?.render(PostDetailViewState(item: nil, imageData: nil, errorMessage: PostDetailText.failedToLoadPost))
                }
            }
        }
    }

    func loadImage(from url: String) {
        Task {
            do {
                let data = try await dataRepository.fetchImage(from: url)
                await MainActor.run {
                    viewController?.render(PostDetailViewState(item: nil, imageData: data, errorMessage: nil))
                }
            } catch {
                print("\(Constants.imageLoad): \(error)")
                await MainActor.run {
                    self.viewController?.render(PostDetailViewState(item: nil, imageData: nil, errorMessage: PostDetailText.failedToLoadPost))
                }
            }
        }
    }

}
