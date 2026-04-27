//
//  UIView + DisableAutoresizing.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

extension UIView {
    func disableAutoresizing(_ views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}
