//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Svetlana on 2026/3/2.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackersViewController()
        assertSnapshot(of: vc, as: .image)
        }

}
