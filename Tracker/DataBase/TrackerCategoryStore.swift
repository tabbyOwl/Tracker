//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData

protocol TrackerCategoryStoreProtocol {
    func fetchAll() -> [TrackerCategory]
    func addCategory(id: UUID, name: String)
    func updateCategory(id: UUID, newName: String)
    func deleteCategory(id: UUID)
}

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchAll() -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.map(TrackerCategory.init)
    }

    func fetchCategory(by id: UUID) -> TrackerCategoryCoreData? {
            let request = TrackerCategoryCoreData.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            return try? context.fetch(request).first
        }
    
    func addCategory(id: UUID, name: String) {
        let category = TrackerCategoryCoreData(context: context)
        category.id = id
        category.name = name

        CoreDataStack.shared.saveContext()
    }
    
    func updateCategory(id: UUID, newName: String) {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let category = try? context.fetch(request).first else {
            return
        }

        category.name = newName
        CoreDataStack.shared.saveContext()
    }
    
    func deleteCategory(id: UUID) {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let category = try? context.fetch(request).first else {
            return
        }

        context.delete(category)
        CoreDataStack.shared.saveContext()
    }
}
