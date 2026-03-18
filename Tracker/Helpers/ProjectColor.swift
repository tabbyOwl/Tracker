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
    case gray
    case lightGray
    case blue
    
    case gradientRed
    case gradientBlue
    case gradientGreen
    
    var color: UIColor {
        switch self {
        case .backgroundDay:
            UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        case .blackDay:
            UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        case .red:
            UIColor(red: 245/255, green: 107/255, blue: 108/255, alpha: 1)
        case .gray:
            UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        case .lightGray:
            UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 1)
        case .blue:
            UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        
        case .gradientRed:
            UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1)
        case .gradientBlue:
            UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1)
        case .gradientGreen:
            UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1)
        }
    }
}

extension UIColor {
    static func projectColor(_ color: ProjectColor) -> UIColor {
        color.color
    }
}
