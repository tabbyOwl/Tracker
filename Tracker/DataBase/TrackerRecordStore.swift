//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData

final class TrackerRecordStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func toggle(trackerId: UUID, date: Date) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "id == %@ AND date == %@",
            trackerId as CVarArg,
            date as NSDate
        )

        if let record = try? context.fetch(request).first {
            context.delete(record)
        } else {
            let record = TrackerRecordCoreData(context: context)
            record.id = trackerId
            record.date = date
        }

        CoreDataStack.shared.saveContext()
    }

    func fetchAll() -> Set<TrackerRecord> {
        let request = TrackerRecordCoreData.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return Set(result.map(TrackerRecord.init))
    }
    
    func fetch(for date: Date) -> Set<TrackerRecord> {
        let day = Calendar.current.startOfDay(for: date)

        let request: NSFetchRequest<TrackerRecordCoreData> =
            TrackerRecordCoreData.fetchRequest()

        request.predicate = NSPredicate(
            format: "date == %@",
            day as NSDate
        )

        do {
            let objects = try context.fetch(request)
            return Set(objects.compactMap { coreData in
               
                    let id = coreData.id
                    let date = coreData.date
        
                return TrackerRecord(id: id, date: date)
            })
        } catch {
            print("Fetch records error:", error)
            return []
        }
    }
    
    func completedDaysCount(trackerId: UUID) -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> =
            TrackerRecordCoreData.fetchRequest()

        request.predicate = NSPredicate(
            format: "id == %@",
            trackerId as NSUUID
        )

        do {
            return try context.count(for: request)
        } catch {
            print("Count error:", error)
            return 0
        }
    }
}
