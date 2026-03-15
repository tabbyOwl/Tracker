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
            return L10n.filterAll
        case .today:
            return L10n.filterToday
        case .completed:
            return L10n.filterCompleted
        case .uncompleted:
            return L10n.filterUncompleted
        }
    }
}

extension FilterType {
    var isActive: Bool {
        self != .all && self != .today
    }
}
