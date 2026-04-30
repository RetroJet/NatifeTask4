//
//  UIView + AddSubviews.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
