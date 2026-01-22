//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData

final class CoreDataStack {

    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "TrackerDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data error: \(error)")
            }
        }
    }

    func saveContext() {
        let context = context
        if context.hasChanges {
            try? context.save()
        }
    }
}
