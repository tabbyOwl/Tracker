//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData


final class TrackerCategoryStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchAll() -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.map(TrackerCategory.init)
    }

    func getOrCreate(id: UUID, name: String) -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        if let category = try? context.fetch(request).first {
            return category
        }

        let category = TrackerCategoryCoreData(context: context)
        category.id = id
        category.name = name
        return category
    }
}
