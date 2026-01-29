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
    let schedule: Set<WeekDay>
}

extension Tracker {
    init(coreData: TrackerCoreData) {
        self.init(
            id: coreData.id,
            name: coreData.name,
            color: UIColor(hex: coreData.color),
            emoji: coreData.emoji,
            schedule: ScheduleMapper.decode(coreData.schedule)
        )
    }
}
