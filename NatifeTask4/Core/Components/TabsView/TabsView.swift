//
//  TabsView.swift
//  NatifeTask4
//
//  Created by Nazar on 30.03.2026.
//

import UIKit

final class TabsView: UIView {

    // MARK: - UI Elements

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: TabCell.self)
        return collectionView
    }()

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        return layout
    }()

    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 2
        return view
    }()

    // MARK: - Properties

    var onTabSelected: ((Int) -> Void)?
    private var items: [String] = []
    private var selectedIndex = 0

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds != .zero else { return }
        setupIndicator(animated: false)
    }
}

// MARK: - Internal Methods

extension TabsView {
    func configure(with items: [String], selectedIndex: Int = 0) {
        self.items = items
        self.selectedIndex = max(0, min(selectedIndex, items.count - 1))
        collectionView.reloadData()
        layoutIfNeeded()
        setupIndicator(animated: false)
    }

    func setSelected(index: Int) {
        guard index != selectedIndex, index < items.count else { return }
        let previousIndex = selectedIndex
        selectedIndex = index
        collectionView.reloadItems(at: [
            IndexPath(item: previousIndex, section: 0),
            IndexPath(item: index, section: 0)
        ])
        setupIndicator(animated: false)
    }
}

// MARK: - Private Methods

private extension TabsView {
    func setupView() {
        addSubview(collectionView)
        collectionView.addSubview(indicatorView)
    }

    func setupIndicator(animated: Bool) {
        let indexPath = IndexPath(item: selectedIndex, section: 0)
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }

        UIView.animate(withDuration: animated ? Animation.duration : 0) {
            self.indicatorView.frame = CGRect(
                x: attributes.frame.minX,
                y: self.collectionView.bounds.height - Layout.indicatorHeight,
                width: attributes.frame.width,
                height: Layout.indicatorHeight
            )
        }
    }
}

private extension TabsView {
    func setupLayout() {
        disableAutoresizing(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension TabsView {
    enum Layout {
        static let itemPadding: CGFloat = 32
        static let indicatorHeight: CGFloat = 3
    }

    enum Animation {
        static let duration: TimeInterval = 0.25
    }
}

// MARK: - UICollectionViewDataSource

extension TabsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: TabCell = collectionView.dequeue(
            for: indexPath
        )
        cell
            .configure(
            title: items[indexPath.item],
            isSelected: indexPath.item == selectedIndex
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if items.count <= 3 {
            return CGSize(
                width: collectionView.bounds.width / CGFloat(items.count),
                height: collectionView.bounds.height
            )
        }

        let textWidth = items[indexPath.item]
            .size(withAttributes: [.font: TabFont.tab]).width + Layout.itemPadding
        return CGSize(width: textWidth, height: collectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDelegate

extension TabsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != selectedIndex else { return }

        let previousIndex = selectedIndex
        selectedIndex = indexPath.item
        onTabSelected?(indexPath.item)

        collectionView.reloadItems(at: [
            IndexPath(item: previousIndex, section: 0),
            indexPath
        ])

        UIView.animate(withDuration: Animation.duration) {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        setupIndicator(animated: true)
    }
}
