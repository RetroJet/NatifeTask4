//
//  PostsListPresenter.swift
//  NatifeTask4
//
//  Created by Nazar on 05.04.2026.
//

import Foundation

protocol PostsListPresenterProtocol: AnyObject {
    func fetchPosts()
    func toggleExpand(_ postId: Int)
    func openPostDetail(_ postId: Int)
    func search(_ query: String)
    func switchLayout(_ type: LayoutType)
}

final class PostsListPresenter {

    // MARK: - Properties

    private var currentQuery = Constants.currentQuery
    private var currentLayout: LayoutType = .list
    private var allPosts: [PostsListsInfo] = []
    private var expandedItems: Set<Int> = []
    private var searchTask: Task<Void, Never>?

    private weak var viewController: PostsListViewControllerProtocol?
    private let viewStateFactory: PostsListViewStateFactoryProtocol
    private let dataRepository: any DataRepositoryProtocol
    private let router: PostsListRouterProtocol

    // MARK: - Initializers

    init(
        viewStateFactory: PostsListViewStateFactoryProtocol,
        viewController: PostsListViewControllerProtocol,
        dataRepository: any DataRepositoryProtocol,
        router: PostsListRouterProtocol
    ) {
        self.viewStateFactory = viewStateFactory
        self.viewController = viewController
        self.dataRepository = dataRepository
        self.router = router
    }
}

// MARK: - Private Methods

private extension PostsListPresenter {
    func makeState(posts: [PostsListsInfo]) -> PostsListViewState {
        viewStateFactory.make(PostsListViewStateFactoryInput(
            posts: posts,
            expandedItems: expandedItems,
            layoutType: currentLayout
        ))
    }

    enum Constants {
        static let fetchPosts = "FetchPosts error"
        static let currentQuery = ""
        static let minSearchLenght = 2
    }
}

// MARK: - PostsListPresenterProtocol

extension PostsListPresenter: PostsListPresenterProtocol {
    func toggleExpand(_ postId: Int) {
        if expandedItems.contains(postId) {
            expandedItems.remove(postId)
        } else {
            expandedItems.insert(postId)
        }

        viewController?.render(makeState(posts: allPosts))
    }

    func fetchPosts() {
        Task {
            do {
                let posts = try await dataRepository.fetchPosts()
                allPosts = posts
                
                await MainActor.run {
                    search(currentQuery)
                }
            } catch {
                print("\(Constants.fetchPosts): \(error)")
                await MainActor.run {
                    viewController?.showError(PostsListText.failedToLoadPosts)
                }
            }
        }
    }

    func switchLayout(_ type: LayoutType) {
        guard type != currentLayout else { return }
        currentLayout = type
        viewController?.render(makeState(posts: allPosts))
    }

    func openPostDetail(_ postId: Int) {
        router.openPostDetail(postId)
    }

    func search(_ query: String) {
        searchTask?.cancel()
        currentQuery = query

        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.count >= Constants.minSearchLenght else {

            viewController?.render(makeState(posts: allPosts))
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(0.5))
            guard let self, !Task.isCancelled else { return }

            let filtered = allPosts.filter {
                $0.previewText.range(of: trimmed, options: .caseInsensitive) != nil
            }
            await MainActor.run {
                self.viewController?.render(self.makeState(posts: filtered))
            }
        }
    }
}
