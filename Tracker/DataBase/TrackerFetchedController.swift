//
//  TrackerFetchedController.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/16.
//
import CoreData

final class TrackerFetchedController: NSObject {

    private let fetchedResultsController: NSFetchedResultsController<TrackerCoreData>

    var onChange: (() -> Void)?

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {

        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        try? fetchedResultsController.performFetch()
    }

    func trackers() -> [Tracker] {
        fetchedResultsController.fetchedObjects?.map(Tracker.init) ?? []
    }
}


