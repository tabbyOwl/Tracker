//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import Foundation

struct TrackerCategory {
    static let defaultId = UUID()
    let id: UUID
    let name: String
    let trackers: [Tracker]
}
