//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
import CoreData
import Logging

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    private let logger = Logger(label: "TrackerRecordStore")
    
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
        
        do {
            if let record = try context.fetch(request).first {
                context.delete(record)
            } else {
                let record = TrackerRecordCoreData(context: context)
                record.id = trackerId
                record.date = date
            }
            
            CoreDataStack.shared.saveContext()
        } catch {
            logger.error(
                "Failed to toggle tracker record",
                metadata: [
                    "trackerId": "\(trackerId)",
                    "date": "\(date)",
                    "error": "\(error)"
                ]
            )
            
            assertionFailure("Toggle tracker record failed: \(error)")
        }
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
            logger.error(
                "Failed to fetch tracker records for date",
                metadata: [
                    "date": "\(date)",
                    "error": "\(error)"
                ]
            )
            assertionFailure("Fetch tracker records for date failed: \(error)")
            return []
        }
    }
    
    func isCompleted(trackerId: UUID, on date: Date) -> Bool {
        let day = Calendar.current.startOfDay(for: date)
        
        let request: NSFetchRequest<TrackerRecordCoreData> =
        TrackerRecordCoreData.fetchRequest()
        
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            day as NSDate
        )
        
        do {
               let count = try context.count(for: request)
               return count > 0
           } catch {
               logger.error(
                   "Failed to check tracker completion",
                   metadata: [
                       "trackerId": "\(trackerId)",
                       "date": "\(date)",
                       "error": "\(error)"
                   ]
               )
               assertionFailure("Check tracker completion failed: \(error)")
               return false
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
            logger.error(
                "Failed to count completed days",
                metadata: [
                    "trackerId": "\(trackerId)",
                    "error": "\(error)"
                ]
            )
            assertionFailure("Count completed days failed: \(error)")
            return 0
        }
    }
}
