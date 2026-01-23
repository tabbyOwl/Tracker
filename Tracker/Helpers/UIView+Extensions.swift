//
//  UIView+Extensions.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
