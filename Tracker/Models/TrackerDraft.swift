//
//  TrackerDraft.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/14.
//
import Foundation

struct TrackerDraft {
    let type: TrackerType
    let name: String
    let schedule: Set<WeekDay>
    let categoryId: UUID
}
