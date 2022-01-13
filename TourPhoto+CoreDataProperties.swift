//
//  TourPhoto+CoreDataProperties.swift
//  assignment
//
//  Created by Paul Lau on 13/1/2022.
//
//

import Foundation
import CoreData


extension TourPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TourPhoto> {
        return NSFetchRequest<TourPhoto>(entityName: "TourPhoto")
    }

    @NSManaged public var title: String?
    @NSManaged public var point: Int32
    @NSManaged public var photoImage: Data?
    @NSManaged public var tourId: String?

}

extension TourPhoto : Identifiable {

}
