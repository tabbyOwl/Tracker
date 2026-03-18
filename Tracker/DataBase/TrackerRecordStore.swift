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
        let day = Calendar.current.startOfDay(for: date)
        
        do {
            let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            trackerRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
            trackerRequest.fetchLimit = 1
            
            guard let tracker = try context.fetch(trackerRequest).first else {
                print("Tracker not found for id: \(trackerId)")
                return
            }
            
            let recordRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
            recordRequest.predicate = NSPredicate(
                format: "tracker == %@ AND date == %@",
                tracker,
                day as NSDate
            )
            recordRequest.fetchLimit = 1
            
            if let existingRecord = try context.fetch(recordRequest).first {
                context.delete(existingRecord)
            } else {
                let record = TrackerRecordCoreData(context: context)
                record.tracker = tracker
                record.date = day
            }
            
            CoreDataStack.shared.saveContext()

        } catch {
            logger.error(
                "Error toggling tracker record",
                metadata: [
                    "error": "\(error)"
                ]
            )
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
                
                let date = coreData.date
                let id = coreData.tracker.id
                
                return TrackerRecord(trackerId: id, date: date)
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
            format: "tracker.id == %@",
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
    
    func totalCompletedCount() -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> =
        TrackerRecordCoreData.fetchRequest()
        
        do {
            return try context.count(for: request)
        } catch {
            logger.error("Failed to count all completed trackers")
            return 0
        }
    }
    
    func averageCompletedTrackersPerDay() -> Int {
        let request: NSFetchRequest<TrackerRecordCoreData> =
        TrackerRecordCoreData.fetchRequest()

        do {
            let completedRecords = try context.fetch(request)
            
            let uniqueDates = Set(completedRecords.map { Calendar.current.startOfDay(for: $0.date) })
            
            let completedTrackersCount = completedRecords.count
            
            return uniqueDates.isEmpty ? 0 : completedTrackersCount / uniqueDates.count
            
        } catch {
            logger.error("Failed to fetch tracker records")
            return 0
        }
    }
    
    func fetchAll() -> [TrackerRecord] {
        let request = TrackerRecordCoreData.fetchRequest()
        let result = (try? context.fetch(request)) ?? []
        return result.map(TrackerRecord.init)
    }
    
}
