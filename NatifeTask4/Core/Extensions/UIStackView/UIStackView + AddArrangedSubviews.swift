//
//  UIStackView + AddArrangedSubviews.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}
