//
//  MainScreenEvent.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/24.
//

enum MainScreenEvent: String {
    case open
    case close
    case click
}

enum Screen: String {
   case main
}

enum MainScreenItem: String {
    case addTrack = "add_track"
    case filter = "filter"
    case track = "track"
}
