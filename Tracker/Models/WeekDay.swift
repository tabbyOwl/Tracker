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
        case .monday: return L10n.weekdayMonday
        case .tuesday: return L10n.weekdayTuesday
        case .wednesday: return L10n.weekdayWednesday
        case .thursday: return L10n.weekdayThursday
        case .friday: return L10n.weekdayFriday
        case .saturday: return L10n.weekdaySaturday
        case .sunday: return L10n.weekdaySunday
        }
    }
    
    var shortTitle: String {
        switch self {
        case .monday: return L10n.weekdayShortMonday
        case .tuesday: return L10n.weekdayShortTuesday
        case .wednesday: return L10n.weekdayShortWednesday
        case .thursday: return L10n.weekdayShortThursday
        case .friday: return L10n.weekdayShortFriday
        case .saturday: return L10n.weekdayShortSaturday
        case .sunday: return L10n.weekdayShortSunday
        }
    }
}
