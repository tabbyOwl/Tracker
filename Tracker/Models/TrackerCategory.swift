//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//
import Foundation

struct TrackerCategory {
    let id: UUID
    let name: String
    let trackers: [Tracker]
}

extension TrackerCategory {
    init(coreData: TrackerCategoryCoreData) {
        let trackers = (coreData.trackers as? Set<TrackerCoreData> ?? [])
            .map(Tracker.init)

        self.init(
            id: coreData.id,
            name: coreData.name,
            trackers: trackers
        )
    }
}
