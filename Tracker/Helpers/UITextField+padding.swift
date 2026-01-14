//
//  UITextField+padding.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import UIKit

extension UITextField {
    func setLeftPadding(_ value: CGFloat) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 1))
        leftView = view
        leftViewMode = .always
    }
}
