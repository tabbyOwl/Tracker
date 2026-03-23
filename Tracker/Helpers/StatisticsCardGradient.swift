//
//  StatisticsCardGradient.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/23.
//

import UIKit

enum Gradient {
    case red
    case blue
    case green

    var colors: [UIColor] {
        switch self {
        case .red:
            return [UIColor(hex: "#FD4C49"), UIColor(hex: "#FF6B6B")]
        case .blue:
            return [UIColor(hex: "#007BFA"), UIColor(hex: "#4DA3FF")]
        case .green:
            return [UIColor(hex: "#46E69D"), UIColor(hex: "#7CF2C0")]
        }
    }
}
