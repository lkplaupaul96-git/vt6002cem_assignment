//
//  TourRecord+CoreDataProperties.swift
//  assignment
//
//  Created by Paul Lau on 13/1/2022.
//
//

import Foundation
import CoreData


extension TourRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TourRecord> {
        return NSFetchRequest<TourRecord>(entityName: "TourRecord")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var imageData: Data?
    @NSManaged public var point: Int32
    @NSManaged public var tourId: String?

}

extension TourRecord : Identifiable {

}
