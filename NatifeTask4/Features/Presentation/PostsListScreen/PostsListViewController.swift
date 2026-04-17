//
//  PostsListViewController.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

protocol PostsListViewControllerProtocol: AnyObject {
    func render(_ state: PostsListViewState)
    func showError(_ message: String)
}

final class PostsListViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(cell: PostsListCell.self)
        return collectionView
    }()

    private lazy var diffableDataSource: UICollectionViewDiffableDataSource<Int, Int> = {
        let dataSource = UICollectionViewDiffableDataSource<Int, Int>(
            collectionView: collectionView) { [weak self] collectionView, indexPath, postId in
                guard let self else { return UICollectionViewCell() }
                guard let viewState = viewStateItems.first(where: { $0.id == postId }) else {
                    return UICollectionViewCell()
                }
                let cell: PostsListCell = collectionView.dequeue(for: indexPath)
                cell.configure(with: viewState)
                cell.expandButtonTapped = { [weak self] in
                    self?.presenter.toggleExpand(postId)
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

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = Constants.searchBarPlaceholder
        return searchBar
    }()

    // MARK: - Properties

    var presenter: PostsListPresenterProtocol!
    private var currentLayout: LayoutType = .list
    private var viewStateItems: [PostsListItemViewState] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
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
            searchBar,
            tabsView,
            collectionView
        )
    }

    func setupDelegates() {
        searchBar.delegate = self
    }

    func setupNavigationBar() {
        title = CommonText.navigationBarTitle

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
            searchBar,
            tabsView,
            collectionView
        )

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tabsView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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

    func applySnapshot(with items: [PostsListItemViewState]) {
        viewStateItems = items
        let newIds = items.map(\.id)
        let currentIds = diffableDataSource.snapshot().itemIdentifiers

        if !currentIds.isEmpty && Set(newIds) == Set(currentIds) {
            var snapshot = diffableDataSource.snapshot()
            snapshot.reconfigureItems(currentIds)
            diffableDataSource.apply(snapshot, animatingDifferences: true)
            UIView.animate(withDuration: 0.3) {
                self.collectionView.layoutIfNeeded()
            }
        } else {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
            snapshot.appendSections([0])
            snapshot.appendItems(newIds)
            diffableDataSource.apply(snapshot, animatingDifferences: true)
        }
    }

}

private extension PostsListViewController {
    enum Constants {
        static let searchBarPlaceholder = "Search"
        static let tabsViewItems = ["List", "Grid", "Gallery"]
    }

    enum Grid {
        static let textHorizontalInset: CGFloat = 40
        static let compactVerticalInset: CGFloat = 98
        static let expandedVerticalInset: CGFloat = 163
    }
}

// MARK: - UICollectionViewDelegate

extension PostsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let postId = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        presenter.openPostDetail(postId)
    }
}

// MARK: - PostsListViewControllerProtocol

extension PostsListViewController: PostsListViewControllerProtocol {
    func render(_ state: PostsListViewState) {
        applySnapshot(with: state.items)

        guard state.selectedTab != currentLayout else { return }
        currentLayout = state.selectedTab

        let layout: UICollectionViewLayout
        switch state.selectedTab {
        case .list: layout = createListLayout()
        case .grid: layout = createGridLayout()
        case .gallery: layout = createGalleryLayout()
        }

        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: PostsListText.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }

    func switchLayout(_ type: LayoutType) {
        presenter.switchLayout(type)
    }
}

// MARK: - WaterfallLayoutDelegate

extension PostsListViewController: WaterfallLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForItemAt indexPath: IndexPath,
        width: CGFloat
    ) -> CGFloat {
        guard let id = diffableDataSource.itemIdentifier(for: indexPath),
              let viewState = viewStateItems.first(where: { $0.id == id }) else { return 0 }

        let textHorizontalInset = Grid.textHorizontalInset
        let maxWidth = width - textHorizontalInset
        let font = UIFont.systemFont(ofSize: 17)

        let boundingBox = viewState.previewText.boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        let labelHeight = ceil(boundingBox.height)
        let collapsedTextHeight = ceil(font.lineHeight * 2)

        let compactVerticalInset = Grid.compactVerticalInset
        let expandedVerticalInset = Grid.expandedVerticalInset

        let fitsWithoutExpand = labelHeight <= collapsedTextHeight

        if fitsWithoutExpand {
            return labelHeight + compactVerticalInset
        }

        return viewState.isExpanded
        ? (labelHeight + expandedVerticalInset)
        : (collapsedTextHeight + expandedVerticalInset)
    }
}

extension PostsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
