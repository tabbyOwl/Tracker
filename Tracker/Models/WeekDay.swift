//
//  WeekDay.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/12.
//
import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    
    init?(date: Date) {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let weekday = calendar.component(.weekday, from: startOfDay)
            self.init(rawValue: weekday)
        }
    
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var displayOrder: Int {
            switch self {
            case .monday: return 1
            case .tuesday: return 2
            case .wednesday: return 3
            case .thursday: return 4
            case .friday: return 5
            case .saturday: return 6
            case .sunday: return 7
            }
        }
    
    var title: String {
        switch self {
        case .monday: return L10n.Weekday.monday
        case .tuesday: return L10n.Weekday.tuesday
        case .wednesday: return L10n.Weekday.wednesday
        case .thursday: return L10n.Weekday.thursday
        case .friday: return L10n.Weekday.friday
        case .saturday: return L10n.Weekday.saturday
        case .sunday: return L10n.Weekday.sunday
        }
    }
    
    var shortTitle: String {
        switch self {
        case .monday: return L10n.Weekday.shortMonday
        case .tuesday: return L10n.Weekday.shortTuesday
        case .wednesday: return L10n.Weekday.shortWednesday
        case .thursday: return L10n.Weekday.shortThursday
        case .friday: return L10n.Weekday.shortFriday
        case .saturday: return L10n.Weekday.shortSaturday
        case .sunday: return L10n.Weekday.shortSunday
        }
    }
}
