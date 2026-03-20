//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/15.
//
import Foundation

final class StatisticsViewModel {
    
    private var trackers: [Tracker] {
        fetchedController.trackers()
    }
    private let fetchedController = TrackerFetchedController()
    private let recordStore = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    
    func getStatistics() -> (bestStreak: Int, perfectDays: Int, completedTrackers: Int, average: Int) {
        let bestStreak = getBestStreak()
        let perfectDays = getPerfectDaysCount()
        let completedTrackers = getAllCompletedTrackersCount()
        let average = getAverageCountPerDays()
        
        return (bestStreak, perfectDays, completedTrackers, average)
    }
    
    func getStatisticsCards() -> [StatisticsCardView] {
        return [
            StatisticsCardView(title: L10n.bestStreakCardTitle),
            StatisticsCardView(title: L10n.perfectDaysCardTitle),
            StatisticsCardView(title: L10n.completedTrackersCardTitle),
            StatisticsCardView(title: L10n.averageCardTitle)
        ]
    }
    
    func getStatisticsValues() -> [Int] {
        let statistics = getStatistics()
        return [statistics.bestStreak, statistics.perfectDays, statistics.completedTrackers, statistics.average]
    }
    
    func hasData() -> Bool {
        let statistics = getStatistics()
        return (statistics.bestStreak + statistics.perfectDays + statistics.completedTrackers + statistics.average) != 0
    }
    
    // MARK: - Private methods
    private func getAllCompletedTrackersCount() -> Int {
        recordStore.totalCompletedCount()
    }
    
    private func getAverageCountPerDays() -> Int {
        recordStore.averageCompletedTrackersPerDay()
    }
    
    private func getBestStreak() -> Int {
        let calendar = Calendar.current
        
        let days = getPerfectDays().sorted()
        
        guard !days.isEmpty else { return 0 }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<days.count {
            let previous = days[i - 1]
            let current = days[i]
            
            if calendar.date(byAdding: .day, value: 1, to: previous) == current {
                currentStreak += 1
            } else {
                maxStreak = max(maxStreak, currentStreak)
                currentStreak = 1
            }
        }
        
        return max(maxStreak, currentStreak)
    }
    
    private func getPerfectDays() -> [Date] {
        let calendar = Calendar.current
        let trackers = trackerStore.fetchAll()
        
        let groupedRecords = getGroupedByDateRecords()
        return groupedRecords.compactMap { (date, records) -> Date? in
            let active = trackers.filter {
                $0.type == .habit && isTracker($0, activeOn: date)
            }
            
            let completed = Set(records.map(\.trackerId))
            
            let isPerfect = !active.isEmpty &&
            active.allSatisfy { completed.contains($0.id) }
            
            return isPerfect ? date : nil
        }
    }
    
    private func getPerfectDaysCount() -> Int {
        let trackers = trackerStore.fetchAll()
        let groupedRecords = getGroupedByDateRecords()
        
        return groupedRecords.reduce(0) { result, element in
            let (date, recordsForDay) = element
            
            let activeTrackers = trackers.filter {
                isTracker($0, activeOn: date)
            }
            
            let completedIds = Set(recordsForDay.map { $0.trackerId })
            
            let isPerfect = !activeTrackers.isEmpty &&
            activeTrackers.allSatisfy { completedIds.contains($0.id) }
            
            return result + (isPerfect ? 1 : 0)
        }
    }
    
    private func getGroupedByDateRecords() -> [Date: [TrackerRecord]] {
        let calendar = Calendar.current
        let records = recordStore.fetchAll()
        
        let grouped = Dictionary(grouping: records) {
            calendar.startOfDay(for: $0.date)
        }
        
        return grouped
    }
    
    private func isTracker(_ tracker: Tracker, activeOn date: Date) -> Bool {
        guard tracker.type == .habit else { return false }
        
        let weekdayInt = Calendar.current.component(.weekday, from: date)
        
        guard let weekday = WeekDay(rawValue: weekdayInt) else { return false }
        return tracker.schedule.contains(weekday)
    }
}
