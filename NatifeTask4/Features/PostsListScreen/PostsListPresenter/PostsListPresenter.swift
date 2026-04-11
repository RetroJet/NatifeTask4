//
//  PostsListPresenter.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import Foundation

protocol PostsListPresenterProtocol: AnyObject {
    func fetchPosts()
    func isExpanded(_ postId: Int) -> Bool
    func toggleExpand(_ postId: Int)
    func openPostDetail(_ postId: Int)
    func search(_ query: String)
}

final class PostsListPresenter {

    // MARK: - Properties

    private var allPosts: [Post] = []
    private var expandedItems: Set<Int> = []
    private weak var viewController: PostsListViewControllerProtocol?
    private let dataRepository: DataRepository
    private let router: PostsListRouterProtocol

    // MARK: - Initializers

    init(
        viewController: PostsListViewControllerProtocol,
        dataRepository: DataRepository,
        router: PostsListRouterProtocol
    ) {
        self.viewController = viewController
        self.dataRepository = dataRepository
        self.router = router
    }
}

// MARK: - Private Methods

private extension PostsListPresenter {
    enum Constants {
        static let fetchPosts = "FetchPosts error"
    }
}

// MARK: - PostsListPresenterProtocol

extension PostsListPresenter: PostsListPresenterProtocol {
    func fetchPosts() {
        Task {
            do {
                let posts = try await dataRepository.fetchPosts()
                allPosts = posts
                viewController?.showPosts(posts)
            } catch {
                print("\(Constants.fetchPosts): \(error)")
                viewController?.showError(PostsListText.failedToLoadPosts)
            }
        }
    }

    func isExpanded(_ postId: Int) -> Bool {
        expandedItems.contains(postId)
    }

    func toggleExpand(_ postId: Int) {
        if expandedItems.contains(postId) {
            expandedItems.remove(postId)
        } else {
            expandedItems.insert(postId)
        }
    }

    func openPostDetail(_ postId: Int) {
        router.openPostDetail(postId)
    }

    func search(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            viewController?.showPosts(allPosts)
            return
        }
        let filtered = allPosts.filter {
            $0.previewText.range(of: trimmed, options: .caseInsensitive) != nil
        }
        viewController?.showPosts(filtered)
    }
}
