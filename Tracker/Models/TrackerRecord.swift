//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import Foundation

struct TrackerRecord: Hashable {
    let trackerId: UUID
    let date: Date
}

extension TrackerRecord {
    init(coreData: TrackerRecordCoreData) {
        self.init(trackerId: coreData.tracker.id, date: coreData.date)
    }
}
