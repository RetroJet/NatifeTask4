//
//  UICollectionView + Reusable.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

public protocol SelfIdentifiable {}

public extension SelfIdentifiable {
    static var identifier: String {
        String(describing: self)
    }
}

extension UICollectionReusableView: SelfIdentifiable {}

public extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cell: Cell.Type) {
        self.register(cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
    
    func register<T: UICollectionReusableView>(
        view: T.Type,
        for kind: String,
        with identifier: String = T.identifier
    ) {
        self.register(
            view.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: identifier
        )
    }
    
    func dequeue<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: Cell.identifier,
            for: indexPath
        ) as? Cell else {
            fatalError("Cell \(String(describing: Cell.self)) not registered")
        }
        return cell
    }
}
