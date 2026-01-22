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

    func add(_ tracker: Tracker, categoryId: UUID, categoryName: String) {
        let category = categoryStore.getOrCreate(id: categoryId, name: categoryName)

        let object = TrackerCoreData(context: context)
        object.id = tracker.id
        object.name = tracker.name
        object.emoji = tracker.emoji
        object.color = tracker.color
        object.schedule = tracker.schedule.map { $0.rawValue }
        object.category = category

        CoreDataStack.shared.saveContext()
    }
}
