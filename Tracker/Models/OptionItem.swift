//
//  OptionItem.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/17.
//

import Foundation
import UIKit

enum OptionItem {
    case emoji(id: UUID, value: String)
    case color(id: UUID, value: UIColor)
}

extension OptionItem: Equatable {
    static func == (lhs: OptionItem, rhs: OptionItem) -> Bool {
        lhs.id == rhs.id
    }

    private var id: UUID {
        switch self {
        case .emoji(let id, _), .color(let id, _):
            return id
        }
    }
}
