//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/31.
//
import UIKit

final class TrackerFormViewModel {
    
    var navigationTitle: String {
        switch mode {
        case .create:
            trackerType == .habit ? L10n.Tracker.newHabitTitle : L10n.Tracker.newEventTitle
        case .edit:
            trackerType == .habit ? "Редактирование привычки" : "Редактирование события"
        }
    }
    
    var scheduleSubtitle: String? {
        guard !selectedSchedule.isEmpty else { return nil }
        
        if selectedSchedule.count == WeekDay.allCases.count {
            return L10n.Tracker.scheduleEveryDay
        }
        
        return selectedSchedule
            .sorted { $0.displayOrder < $1.displayOrder }
            .map { $0.shortTitle }
            .joined(separator: ", ")
    }
    
    // MARK: - State updates
    var onCreateButtonStateChanged: ((Bool) -> Void)?
    var onScheduleChanged: ((String) -> Void)?
    var onCategoryChanged: (() -> Void)?
    
    // MARK: - Private state
    private let mode: TrackerFormMode
    private var editingTracker: Tracker?
    private let trackerType: TrackerType
    private var name: String = "" { didSet { validate() } }
    private var selectedEmoji: String? { didSet { validate() } }
    private var selectedColor: UIColor? { didSet { validate() } }
    private var selectedSchedule: Set<WeekDay> = [] {
        didSet {
            if selectedSchedule != oldValue {
                onScheduleChanged?(scheduleSubtitle ?? "")
                validate()
            }
        }
    }
    
    private var category: TrackerCategory? {
        didSet {
            validate()
            onCategoryChanged?()
        }
    }
    
    // MARK: - Init
    init(mode: TrackerFormMode) {
        self.mode = mode

        switch mode {

        case .create(let type):
            self.trackerType = type

        case .edit(let tracker, let category):
            self.trackerType = tracker.type
            self.editingTracker = tracker

            self.name = tracker.name
            self.selectedEmoji = tracker.emoji
            self.selectedColor = tracker.color
            self.selectedSchedule = tracker.schedule
            self.category = category
        }
    }
    
    // MARK: - Setters
    func setName(_ name: String) {
        self.name = name
    }
    
    func getName() -> String {
        name
    }
    
    func setSelectedEmoji(_ emoji: String) {
        selectedEmoji = emoji
    }
    
    func getSelectedEmojiItem() -> OptionItem? {

        guard let emoji = selectedEmoji else { return nil }

        return EmojiLibrary.all.first {

            if case .emoji(_, let value) = $0 {
                return value == emoji
            }

            return false
        }
    }
    
    func setSelectedColor(_ color: UIColor) {
        selectedColor = color
    }
    
    func getSelectedColorItem() -> OptionItem? {

        guard let color = selectedColor else { return nil }

        return ColorLibrary.all.first {

            if case .color(_, let value) = $0 {
                return value == color
            }

            return false
        }
    }
    
    func setSelectedCategory(_ category: TrackerCategory) {
        self.category = category
    }
    
    func setSchedule(_ days: Set<WeekDay>) {
        selectedSchedule = days
    }
    
    // MARK: - Getters
    func getSchedule() -> Set<WeekDay> {
        return selectedSchedule
    }
    
    func getTrackerType() -> TrackerType {
        return trackerType
    }
    
    func getCategoryName() -> String {
        return category?.name ?? ""
    }
    
    func validateForm() {
        validate()
    }
    
    func saveTracker() -> Tracker? {
        guard isFormValid else { return nil }
        guard let category = category,
              let emoji = selectedEmoji,
              let color = selectedColor else { return nil }

        let id = editingTracker?.id ?? UUID()

        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            type: trackerType,
            schedule: trackerType == .habit ? selectedSchedule : [],
            categoryId: category.id,
            isPinned: false
        )
    }
    
    // MARK: - Validation
    private func validate() {
        onCreateButtonStateChanged?(isFormValid)
    }
    
    private var isFormValid: Bool {
        let isNameValid = !name.trimmingCharacters(in: .whitespaces).isEmpty
        let isScheduleValid = trackerType == .habit ? !selectedSchedule.isEmpty : true
        
        return isNameValid
        && category != nil
        && selectedEmoji != nil
        && selectedColor != nil
        && isScheduleValid
    }
}
