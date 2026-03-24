//
//  ScheduleMapper.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/28.
//
import Foundation

enum ScheduleMapper {

    static func decode(_ data: Data) -> Set<WeekDay> {
        (try? JSONDecoder().decode(Set<WeekDay>.self, from: data)) ?? []
    }
    
    static func encode(_ schedule: Set<WeekDay>) -> Data {
        (try? JSONEncoder().encode(Array(schedule))) ?? Data()
    }
}
