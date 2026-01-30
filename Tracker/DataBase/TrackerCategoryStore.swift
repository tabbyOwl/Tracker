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
