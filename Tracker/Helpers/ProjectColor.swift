//
//  Colors.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import UIKit

enum ProjectColor {
    case backgroundDay
    case blackDay
    case red
    
    var color: UIColor {
        switch self {
        case .backgroundDay:
            UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        case .blackDay:
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        case .red:
            UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        }
    }
}

extension UIColor {
    static func projectColor(_ color: ProjectColor) -> UIColor {
        color.color
    }
}
