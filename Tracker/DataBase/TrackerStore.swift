//
//  TrackerStore.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData

final class TrackerStore {

    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore

    init(
        context: NSManagedObjectContext = CoreDataStack.shared.context,
        categoryStore: TrackerCategoryStore = TrackerCategoryStore()
    ) {
        self.context = context
        self.categoryStore = categoryStore
    }

    func add(_ tracker: Tracker, categoryId: UUID) {
        guard let category = categoryStore.fetchCategory(by: categoryId) else {
            assertionFailure("Category with id \(categoryId) not found")
            return
        }

        let object = TrackerCoreData(context: context)
        object.id = tracker.id
        object.name = tracker.name
        object.emoji = tracker.emoji
        object.color = tracker.color.hexString
        object.schedule = ScheduleMapper.encode(tracker.schedule)
        object.category = category

        CoreDataStack.shared.saveContext()
    }
}
