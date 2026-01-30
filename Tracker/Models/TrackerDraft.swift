//
//  TrackerDraft.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import UIKit

struct TrackerDraft {
    let type: TrackerType
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: Set<WeekDay>
    let category: TrackerCategory
}
