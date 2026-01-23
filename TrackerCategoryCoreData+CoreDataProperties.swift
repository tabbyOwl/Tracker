//
//  TrackerCategoryCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/21.
//
//

public import Foundation
public import CoreData


public typealias TrackerCategoryCoreDataCoreDataPropertiesSet = NSSet

extension TrackerCategoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCategoryCoreData> {
        return NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var trackers: NSSet

}

// MARK: Generated accessors for trackers
extension TrackerCategoryCoreData {

    @objc(addTrackersObject:)
    @NSManaged public func addToTrackers(_ value: TrackerCoreData)

    @objc(removeTrackersObject:)
    @NSManaged public func removeFromTrackers(_ value: TrackerCoreData)

    @objc(addTrackers:)
    @NSManaged public func addToTrackers(_ values: NSSet)

    @objc(removeTrackers:)
    @NSManaged public func removeFromTrackers(_ values: NSSet)

}
