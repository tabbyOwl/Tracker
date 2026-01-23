//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import Foundation

struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
}

extension TrackerRecord {
    init(coreData: TrackerRecordCoreData) {
        self.init(id: coreData.id, date: coreData.date)
    }
}
