//
//  Tracker.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let type: TrackerType
    let schedule: Set<WeekDay>
    let categoryId: UUID
    let isPinned: Bool
}

extension Tracker {
    init(coreData: TrackerCoreData) {
        let schedule = ScheduleMapper.decode(coreData.schedule)
        let type: TrackerType = schedule.isEmpty ? .event : .habit
        
        self.init(
            id: coreData.id,
            name: coreData.name,
            color: UIColor(hex: coreData.color),
            emoji: coreData.emoji,
            type: type,
            schedule: schedule,
            categoryId: coreData.category.id,
            isPinned: coreData.isPinned
        )
    }
}
