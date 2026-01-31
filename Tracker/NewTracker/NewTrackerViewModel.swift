//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/31.
//
import UIKit

final class NewTrackerViewModel {
    
    var navigationTitle: String {
        trackerType == .habit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    // MARK: - Output (bindings)
    var onCreateButtonStateChanged: ((Bool) -> Void)?
    var onScheduleChanged: ((String) -> Void)?
    var onCategoryChanged: (() -> Void)?
    
    // MARK: - Private state
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
    init(trackerType: TrackerType) {
        self.trackerType = trackerType
    }
    
    // MARK: - Inputs (from VC)
    func setName(_ name: String) {
        self.name = name
    }
    
    func selectEmoji(_ emoji: String) {
        selectedEmoji = emoji
    }
    
    func selectColor(_ color: UIColor) {
        selectedColor = color
    }
    
    func selectCategory(_ category: TrackerCategory) {
        self.category = category
    }
    
    func setSchedule(_ days: Set<WeekDay>) {
        selectedSchedule = days
    }
    
    func getSelectedSchedule() -> Set<WeekDay> {
        return selectedSchedule
    }
    
    func getTrackerType() -> TrackerType {
        return trackerType
    }
    
    func getCategoryName() -> String {
        return category?.name ?? ""
    }
    
    // MARK: - Outputs (computed)
    var scheduleSubtitle: String? {
        guard !selectedSchedule.isEmpty else { return nil }
        
        if selectedSchedule.count == WeekDay.allCases.count {
            return "Каждый день"
        }
        
        return selectedSchedule
            .sorted { $0.displayOrder < $1.displayOrder }
            .map { $0.shortTitle }
            .joined(separator: ", ")
    }
    
    // MARK: - Actions
    func makeDraft() -> TrackerDraft? {
        guard isFormValid else { return nil }
        guard let category = category,
              let selectedEmoji = selectedEmoji,
              let selectedColor = selectedColor else { return nil }
        
        return TrackerDraft(
            type: trackerType,
            name: name,
            emoji: selectedEmoji,
            color: selectedColor,
            schedule: trackerType == .habit ? selectedSchedule : [],
            categoryId: category.id
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
