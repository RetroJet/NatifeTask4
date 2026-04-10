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

    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(cell: PostCell.self)
        return collectionView
    }()

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, Post> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, Post>(
            collectionView: collectionView) { [weak self] collectionView, indexPath, post in
                guard let self else { return UICollectionViewCell() }
                let cell: PostCell = collectionView.dequeue(for: indexPath)
                let isExpanded = self.presenter.isExpanded(post.postId)
                cell.configure(
                    with: post,
                    isExpanded: isExpanded,
                    isGallery: self.currentLayout == .gallery,
                    isGrid: self.currentLayout == .grid
                )

                cell.expandButtonTapped = { [weak self] in
                    guard let self else { return }
                    self.presenter.toggleExpand(post.postId)

                    var snapshot = self.diffableDataSource.snapshot()
                    snapshot.reconfigureItems([post])
                    self.diffableDataSource.apply(snapshot, animatingDifferences: true)

                    if self.currentLayout == .grid {
                        self.collectionView.collectionViewLayout.invalidateLayout()
                    }
                }

                return cell
            }

        return dataSource
    }()

    private lazy var tabsView: TabsView = {
        let tabsView = TabsView()
        tabsView.configure(with: Constants.tabsViewItems)
        tabsView.onTabSelected = { [weak self] index in
            guard let self else { return }
            switch index {
            case 0: self.switchLayout(.list)
            case 1: self.switchLayout(.grid)
            case 2: self.switchLayout(.gallery)
            default: break
            }
        }
        return tabsView
    }()

    // MARK: - Properties

    var presenter: PostsListPresenterProtocol!
    private var currentLayout: LayoutType = .list

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
        view.addSubviews(
            tabsView,
            collectionView
        )
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
        view.disableAutoresizing(
            tabsView,
            collectionView
        )

        NSLayoutConstraint.activate([
            tabsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabsView.heightAnchor.constraint(equalToConstant: 55),

            collectionView.topAnchor.constraint(equalTo: tabsView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

private extension PostsListViewController {
    func switchLayout(_ type: LayoutType) {
        guard type != currentLayout else { return }
        currentLayout = type

        var snapshot = diffableDataSource.snapshot()
        snapshot.reconfigureItems(snapshot.itemIdentifiers)
        diffableDataSource.apply(snapshot, animatingDifferences: false)

        let layout: UICollectionViewLayout
        switch type {
        case .list: layout = createListLayout()
        case .grid: layout = createGridLayout()
        case .gallery: layout = createGalleryLayout()
        }

        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func createListLayout() -> UICollectionViewLayout {
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

    func createGridLayout() -> UICollectionViewLayout {
        let layout = WaterfallLayout()
        layout.delegate = self
        return layout
    }

    func createGalleryLayout() -> UICollectionViewLayout {
        let itemsize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(300)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemsize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(300)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 40
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
        static let tabsViewItems = ["List", "Grid", "Gallery"]
    }

    enum GridConstants {
        static let textHorizontalInset: CGFloat = 40
        static let compactVerticalInset: CGFloat = 98
        static let expandedVerticalInset: CGFloat = 163
    }

    enum LayoutType {
        case list, grid, gallery
    }
}

// MARK: - UICollectionViewDelegate

extension PostsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let post = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        presenter.openPostDetail(post.postId)
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

    // MARK: - WaterfallLayoutDelegate

    extension PostsListViewController: WaterfallLayoutDelegate {
        func collectionView(
            _ collectionView: UICollectionView,
            heightForItemAt indexPath: IndexPath,
            width: CGFloat
        ) -> CGFloat {
            guard let post = diffableDataSource.itemIdentifier(for: indexPath) else { return 0 }

            let isExpanded = presenter.isExpanded(post.postId)

            let textHorizontalInset = GridConstants.textHorizontalInset
            let maxWidth = width - textHorizontalInset
            let font = UIFont.systemFont(ofSize: 17)

            let boundingBox = post.previewText.boundingRect(
                with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [.font: font],
                context: nil
            )

            let labelHeight = ceil(boundingBox.height)
            let collapsedTextHeight = ceil(font.lineHeight * 2)

            let compactVerticalInset = GridConstants.compactVerticalInset
            let expandedVerticalInset = GridConstants.expandedVerticalInset

            let fitsWithoutExpand = labelHeight <= collapsedTextHeight

            if fitsWithoutExpand {
                return labelHeight + compactVerticalInset
            }

            return isExpanded
                ? (labelHeight + expandedVerticalInset)
                : (collapsedTextHeight + expandedVerticalInset)
        }
    }
