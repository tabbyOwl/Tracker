//
//  TrackerCategoryFetchedController.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData

final class TrackerCategoryFetchedController: NSObject {

    private let fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>

    var onChange: (() -> Void)?

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }

    func categories() -> [TrackerCategory] {
        fetchedResultsController.fetchedObjects?.map(TrackerCategory.init) ?? []
    }
}

extension TrackerCategoryFetchedController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        onChange?()
    }
}

