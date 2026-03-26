//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/5.
//

enum FilterType: CaseIterable {
    case all
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all:
            return L10n.TrackerFilter.all
        case .today:
            return L10n.TrackerFilter.today
        case .completed:
            return L10n.TrackerFilter.completed
        case .uncompleted:
            return L10n.TrackerFilter.uncompleted
        }
    }
}

extension FilterType {
    var isActive: Bool {
        self != .all && self != .today
    }
}
