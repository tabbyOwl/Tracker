//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Svetlana on 2026/3/2.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {

    func testViewController() {
        let viewModel = TrackersViewModel()
        let vc = TrackersViewController(viewModel: viewModel)
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
        }

}
