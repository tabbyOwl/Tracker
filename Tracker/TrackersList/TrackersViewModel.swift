//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/31.
//
import Foundation

final class TrackersViewModel {
    
    // MARK: - Bindings
    var onDataChanged: (() -> Void)?
    
    var isEmpty: Bool {
        filteredCategories.isEmpty
    }
    
    var numberOfRows: Int {
        filteredCategories.count
    }
    
    var isFutureDate: Bool {
        selectedDate > Date()
    }
    
    
    private var categories: [TrackerCategory] = [] {
        didSet {
            updateFilteredCategories()
            onDataChanged?()
        }
    }
    
    private let trackerStore = TrackerStore()
    private let recordStore = TrackerRecordStore()
    private let fetchedController = TrackerCategoryFetchedController()
    
    private var selectedDate: Date = Date() {
        didSet {
            updateFilteredCategories()
            onDataChanged?()
        }
    }
    
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    func setSelectedDate(_ date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        selectedDate = startOfDay
    }
    
    func getTitle(for section: Int) -> String {
        filteredCategories[section].name
    }
    
    
    func getCompletedDaysCount(for trackerId: UUID) -> Int {
        recordStore.completedDaysCount(trackerId: trackerId)
    }
    
    func loadCategories() {
        fetchedController.onChange = { [weak self] in
            self?.categories = self?.fetchedController.categories() ?? []
        }
        
        categories = fetchedController.categories()
        updateFilteredCategories()
        reloadCompletedTrackers()
    }
    
    func updateFilteredCategories() {
        guard let selectedWeekday = WeekDay(date: selectedDate) else { return }
        
        filteredCategories = categories
            .map { category in
                let trackers = category.trackers.filter { tracker in
                    tracker.schedule.isEmpty || tracker.schedule.contains(selectedWeekday)
                }
                return TrackerCategory(
                    id: category.id,
                    name: category.name,
                    trackers: trackers
                )
            }
            .filter { !$0.trackers.isEmpty }
    }
    
    func createTracker(draft: TrackerDraft) {
        let tracker = Tracker(
            id: UUID(),
            name: draft.name,
            color: draft.color,
            emoji: draft.emoji,
            schedule: draft.schedule
        )
        
        trackerStore.add(tracker, categoryId: draft.categoryId)
    }
    
    func getTrackers(for section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func getTrackerForCell(section: Int, item: Int) -> Tracker {
        filteredCategories[section].trackers[item]
    }
    
    func reloadCompletedTrackers() {
        let day = Calendar.current.startOfDay(for: selectedDate)
        completedTrackers = recordStore.fetch(for: day)
    }
    
    func isCompletedToday(for trackerId: UUID) -> Bool {
        completedTrackers.contains {
            $0.id == trackerId
        }
    }
    
    func toggleRecords(for trackerId: UUID) {
        let day = Calendar.current.startOfDay(for: selectedDate)
        recordStore.toggle(trackerId: trackerId, date: day)
    }
    
    private func addTracker(_ tracker: Tracker, to categoryId: UUID) {
        if let index = categories.firstIndex(where: { $0.id == categoryId }) {
            let oldCategory = categories[index]
            
            let updatedCategory = TrackerCategory(id: oldCategory.id, name: oldCategory.name, trackers: oldCategory.trackers + [tracker])
            
            categories[index] = updatedCategory
        } else {
            let newCategory = TrackerCategory(id: categoryId, name: "Дом", trackers: [tracker])
            categories.append(newCategory)
        }
    }
}

