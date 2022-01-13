//
//  TourPoint.swift
//  assignment
//
//  Created by Paul Lau on 9/1/2022.
//

import Foundation
import MapKit
import FirebaseFirestore

struct TourPoint {
    var title:String
    var coordinate:GeoPoint
    
    var coord:CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    var annotation:MKPointAnnotation {
        get {
            let ann = MKPointAnnotation()
            ann.title = title
            ann.coordinate = coord
            return ann
        }
    }
    
    var mapItem:MKMapItem {
        get {
            return MKMapItem(placemark: MKPlacemark(coordinate: coord))
        }
    }
    
//    init(_ title:String, _ coordinate:GeoPoint) {
//        self.title = title
//        self.coordinate = coordinate
//    }
}

struct TourDetail: Identifiable {
    var id:String
    var title:String
    var subtitle:String
    var tourPoints:[TourPoint]
    
//    init(_ title:String, _ subtitle:String, _ tourPoints:[TourPoint]) {
//        self.title = title
//        self.subtitle = subtitle
//        self.tourPoints = tourPoints
//    }
}
