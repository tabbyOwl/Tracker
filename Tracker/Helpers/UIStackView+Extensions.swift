//
//  UIStackView+Extensions.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
