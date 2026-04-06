//
//  PostsListViewController.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

protocol PostsListViewControllerProtocol: AnyObject {
    func showPosts(_ posts: [Post])
    func showError(_ message: String)
}

final class PostsListViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView! = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // collectionView.delegate = self
        collectionView.register(cell: PostCell.self)
        return collectionView
    }()

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, Post> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, Post>(
            collectionView: collectionView) { [weak self] collectionView, indexPath, post in
                guard let self else { return UICollectionViewCell() }
                let cell: PostCell = collectionView.dequeue(for: indexPath)
                let isExpanded = self.presenter.isExpanded(post.postId)
                cell.configure(with: post, isExpanded: isExpanded)

                cell.expandButtonTapped = { [weak self] in
                    guard let self else { return }
                    self.presenter.toggleExpand(post.postId)

                    var snapshot = self.diffableDataSource.snapshot()
                    snapshot.reconfigureItems([post])
                    self.diffableDataSource.apply(snapshot, animatingDifferences: true)
                }

                return cell
            }

        return dataSource
    }()

    // MARK: - Properties

    var presenter: PostsListPresenterProtocol!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
        presenter.fetchPosts()
    }
}

// MARK: - Private Methods

private extension PostsListViewController {
    func setupView() {
        view.addSubview(collectionView)
    }

    func setupNavigationBar() {
        title = Constants.navigationBarTitle

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

private extension PostsListViewController {
    func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

private extension PostsListViewController {
    func createLayout() -> UICollectionViewLayout {

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    func applySnapshot(with posts: [Post]) {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Post>()
            snapshot.appendSections([0])
            snapshot.appendItems(posts)
            diffableDataSource.apply(snapshot)
        }
}

private extension PostsListViewController {
    enum Constants {
        static let navigationBarTitle: String = "Title"
    }
}

// MARK: - PostsListViewControllerProtocol

extension PostsListViewController: PostsListViewControllerProtocol {
    func showPosts(_ posts: [Post]) {
        applySnapshot(with: posts)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: PostsListText.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }
}
