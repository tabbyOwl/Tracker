//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/31.
//
import Foundation

enum TrackersState {
    case emptyTrackers
    case emptyFilter
    case content
}

final class TrackersViewModel {
    
    // MARK: - Bindings
    var onDataChanged: (() -> Void)?
    var onStateChange: ((TrackersState) -> Void)?
    
    var isEmpty: Bool {
        filteredCategories.isEmpty
    }
    
    var numberOfRows: Int {
        filteredCategories.count
    }
    
    var isFutureDate: Bool {
        selectedDate > Date()
    }
    
    var state: TrackersState {
        let hasTrackersForDate = categories
            .flatMap { $0.trackers }
            .contains { tracker in
                guard let weekday = WeekDay(date: selectedDate) else { return false }
                return tracker.schedule.isEmpty || tracker.schedule.contains(weekday)
            }

        if !hasTrackersForDate {
            return .emptyTrackers
        }

        if filteredCategories.isEmpty {
            return .emptyFilter
        }

        return .content
    }
    
    
    private var searchText: String = "" {
        didSet {
            updateFilteredCategories()
        }
    }
    
    private var selectedFilter: FilterType = .all {
        didSet {
            updateFilteredCategories()
        }
    }
    

    private var categories: [TrackerCategory] = [] {
        didSet {
            updateFilteredCategories()
        }
    }
    
    private let trackerStore = TrackerStore()
    private let recordStore = TrackerRecordStore()
    private let fetchedController = TrackerCategoryFetchedController()
    
    private var selectedDate: Date = Date() {
        didSet {
            updateFilteredCategories()
        }
    }
    
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    func setSelectedDate(_ date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        selectedDate = startOfDay
    }
    
    func setSearchText(_ text: String) {
        searchText = text
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
    
    private func notifyState() {
        onStateChange?(state)
    }
    
    func setFilter(_ filter: FilterType) {
        selectedFilter = filter
    }
    
    func getFilter() -> FilterType {
        selectedFilter
    }
    
    
    func updateFilteredCategories() {
        
        guard let selectedWeekday = WeekDay(date: selectedDate) else { return }
        var pinnedTrackers: [Tracker] = []
        
        filteredCategories = categories
            .map { category in
                
                let trackers = category.trackers.filter { tracker in
                    
                    
                    if tracker.isPinned {
                        pinnedTrackers.append(tracker)
                        return false
                    }
                    
                    let matchesSchedule =
                        tracker.schedule.isEmpty ||
                        tracker.schedule.contains(selectedWeekday)
                    
                    if !matchesSchedule { return false }

                    if !searchText.isEmpty {
                        let matchesSearch =
                            tracker.name.lowercased()
                            .contains(searchText.lowercased())
                        
                        if !matchesSearch { return false }
                    }

                    switch selectedFilter {
                    case .all, .today:
                        return true
                    case .completed:
                        return isCompleted(for: tracker.id)
                    case .uncompleted:
                        return !isCompleted(for: tracker.id)
                    }
                }

                return TrackerCategory(
                    id: category.id,
                    name: category.name,
                    trackers: trackers
                )
            }
            .filter { !$0.trackers.isEmpty }
        
        var result: [TrackerCategory] = []

        if !pinnedTrackers.isEmpty {
            result.append(
                TrackerCategory(
                    id: UUID(),
                    name: "Закрепленные",
                    trackers: pinnedTrackers
                )
            )
        }

        result.append(contentsOf: filteredCategories)
        
        filteredCategories = result
        onDataChanged?()
        onStateChange?(state)
    }
    
    func saveTracker(tracker: Tracker) {
        trackerStore.add(tracker)
    }
    
    func getTrackersCount(for section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func getTrackerForCell(section: Int, item: Int) -> Tracker {
        filteredCategories[section].trackers[item]
    }
    
    func reloadCompletedTrackers() {
        let day = Calendar.current.startOfDay(for: selectedDate)
        completedTrackers = recordStore.fetch(for: day)
    }
    
    func isCompleted(for trackerId: UUID) -> Bool {
        completedTrackers.contains {
            $0.id == trackerId
        }
    }
    
    func getCategory(by id: UUID) -> TrackerCategory? {
        categories.first { $0.id == id }
    }
    
    func toggleRecords(for trackerId: UUID) {
        let day = Calendar.current.startOfDay(for: selectedDate)
        recordStore.toggle(trackerId: trackerId, date: day)
    }
    
    func togglePin(for trackerId: UUID) {
        trackerStore.togglePin(trackerId)
        loadCategories()
    }
    
    func updateTracker(tracker: Tracker) {
        trackerStore.update(tracker: tracker)
        loadCategories()
    }
    
    func deleteTracker(byId id: UUID) {
        trackerStore.delete(byId: id)
        onDataChanged?()
    }
    
    private func addTracker(_ tracker: Tracker) {
        if let index = categories.firstIndex(where: { $0.id == tracker.categoryId }) {
            let oldCategory = categories[index]
            
            let updatedCategory = TrackerCategory(id: oldCategory.id, name: oldCategory.name, trackers: oldCategory.trackers + [tracker])
            
            categories[index] = updatedCategory
        }
    }
}

