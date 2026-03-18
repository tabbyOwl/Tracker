//
//  TrackerCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
//
public import UIKit
public import CoreData

public typealias TrackerCoreDataCoreDataPropertiesSet = NSSet

extension TrackerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var color: String
    @NSManaged public var emoji: String
    @NSManaged public var schedule: Data
    @NSManaged public var category: TrackerCategoryCoreData
    @NSManaged public var records: NSSet
    @NSManaged public var isPinned: Bool

}

// MARK: Generated accessors for records
extension TrackerCoreData {

    @objc(addRecordsObject:)
    @NSManaged public func addToRecords(_ value: TrackerRecordCoreData)

    @objc(removeRecordsObject:)
    @NSManaged public func removeFromRecords(_ value: TrackerRecordCoreData)

    @objc(addRecords:)
    @NSManaged public func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged public func removeFromRecords(_ values: NSSet)

}

extension TrackerCoreData : Identifiable {

}
