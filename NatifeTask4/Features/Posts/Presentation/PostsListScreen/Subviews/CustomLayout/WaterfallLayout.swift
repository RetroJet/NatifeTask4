//
//  WaterfallLayout.swift
//  NatifeTask4
//
//  Created by Nazar on 10.04.2026.
//

import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForItemAt indexPath: IndexPath,
        width: CGFloat
    ) -> CGFloat
}

final class WaterfallLayout: UICollectionViewLayout {
    weak var delegate: WaterfallLayoutDelegate?

    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 2

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    override var collectionViewContentSize: CGSize {
        CGSize(
            width: collectionView?.bounds.width ?? 0,
            height: contentHeight
        )
    }

    override func prepare() {
        guard let collectionView, collectionView.numberOfSections > 0 else {
            return
        }

        cache.removeAll()
        contentHeight = 0

        let contentWidth = collectionView.bounds.width
        let columnWidth = contentWidth / CGFloat(numberOfColumns)

        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var yOffset = Array(repeating: CGFloat(0), count: numberOfColumns)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {

            let indexPath = IndexPath(item: item, section: 0)

            let column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0

            let availableWidth = columnWidth - cellPadding * 2

            let itemHeight = delegate?.collectionView(
                collectionView,
                heightForItemAt: indexPath,
                width: availableWidth
            ) ?? 150

            let frame = CGRect(
                x: xOffset[column] + cellPadding,
                y: yOffset[column] + cellPadding,
                width: availableWidth,
                height: itemHeight
            )

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame

            cache.append(attributes)

            yOffset[column] = frame.maxY + cellPadding
            contentHeight = max(contentHeight, frame.maxY)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache.first { $0.indexPath == indexPath }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        collectionView?.bounds.size != newBounds.size
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }
}
