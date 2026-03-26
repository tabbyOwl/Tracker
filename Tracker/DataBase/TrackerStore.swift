//
//  TrackerStore.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import Logging
import CoreData

final class TrackerStore {

    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore
    private let logger = Logger(label: "TrackerStore")

    init(
        context: NSManagedObjectContext = CoreDataStack.shared.context,
        categoryStore: TrackerCategoryStore = TrackerCategoryStore()
    ) {
        self.context = context
        self.categoryStore = categoryStore
    }
    
    func fetchAll() -> [Tracker] {
        let request = TrackerCoreData.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.map(Tracker.init)
    }

    func add(_ tracker: Tracker) {
        guard let category = categoryStore.fetchCategory(by: tracker.categoryId) else {
            assertionFailure("Category with id \(tracker.categoryId) not found")
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
    
    func update(tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        guard let category = categoryStore.fetchCategory(by: tracker.categoryId) else {
            assertionFailure("Category with id \(tracker.categoryId) not found")
            return
        }
        do {
            let result = try context.fetch(fetchRequest)
            
            if let object = result.first {
                object.name = tracker.name
                object.emoji = tracker.emoji
                object.color = tracker.color.hexString
                object.schedule = ScheduleMapper.encode(tracker.schedule)
                object.category = category
                
                CoreDataStack.shared.saveContext()
            }
        } catch {
            logger.error("Error updating Tracker",
                         metadata: ["error": "\(error)"])
        }
    }
    
    func delete(byId id: UUID) {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let result = try context.fetch(fetchRequest)
                
                if let trackerToDelete = result.first {
                    context.delete(trackerToDelete)
                    CoreDataStack.shared.saveContext()
                } else {
                    logger.error("Tracker with id \(id) not found.")
                }
            } catch {
                logger.error("Error fetching Tracker for deletion: \(error)")
            }
        }
    
    func togglePin(_ id: UUID) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            if let tracker = try context.fetch(request).first {
                tracker.isPinned.toggle()
                CoreDataStack.shared.saveContext()
            }
        } catch {
            logger.error("Error toggling pin: \(error)")
        }
    }
}
